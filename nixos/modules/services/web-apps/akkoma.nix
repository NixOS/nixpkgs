{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.akkoma;
  ex = cfg.config;
  db = ex.":pleroma"."Pleroma.Repo";
  web = ex.":pleroma"."Pleroma.Web.Endpoint";

  isConfined = config.systemd.services.akkoma.confinement.enable;
  hasSmtp = (attrByPath [ ":pleroma" "Pleroma.Emails.Mailer" "adapter" "value" ] null ex) == "Swoosh.Adapters.SMTP";

  isAbsolutePath = v: isString v && substring 0 1 v == "/";
  isSecret = v: isAttrs v && v ? _secret && isAbsolutePath v._secret;

  absolutePath = with types; mkOptionType {
    name = "absolutePath";
    description = "absolute path";
    descriptionClass = "noun";
    check = isAbsolutePath;
    inherit (str) merge;
  };

  secret = mkOptionType {
    name = "secret";
    description = "secret value";
    descriptionClass = "noun";
    check = isSecret;
    nestedTypes = {
      _secret = absolutePath;
    };
  };

  ipAddress = with types; mkOptionType {
    name = "ipAddress";
    description = "IPv4 or IPv6 address";
    descriptionClass = "conjunction";
    check = x: str.check x && builtins.match "[.0-9:A-Fa-f]+" x != null;
    inherit (str) merge;
  };

  elixirValue = let
    elixirValue' = with types;
      nullOr (oneOf [ bool int float str (attrsOf elixirValue') (listOf elixirValue') ]) // {
        description = "Elixir value";
      };
  in elixirValue';

  frontend = {
    options = {
      package = mkOption {
        type = types.package;
        description = "Akkoma frontend package.";
        example = literalExpression "pkgs.akkoma-frontends.akkoma-fe";
      };

      name = mkOption {
        type = types.nonEmptyStr;
        description = "Akkoma frontend name.";
        example = "akkoma-fe";
      };

      ref = mkOption {
        type = types.nonEmptyStr;
        description = "Akkoma frontend reference.";
        example = "stable";
      };
    };
  };

  sha256 = builtins.hashString "sha256";

  replaceSec = let
    replaceSec' = { }@args: v:
      if isAttrs v
        then if v ? _secret
          then if isAbsolutePath v._secret
            then sha256 v._secret
            else abort "Invalid secret path (_secret = ${v._secret})"
          else mapAttrs (_: val: replaceSec' args val) v
        else if isList v
          then map (replaceSec' args) v
          else v;
    in replaceSec' { };

  # Erlang/Elixir uses a somewhat special format for IP addresses
  erlAddr = addr: fileContents
    (pkgs.runCommand addr {
      nativeBuildInputs = [ cfg.package.elixirPackage ];
      code = ''
        case :inet.parse_address('${addr}') do
          {:ok, addr} -> IO.inspect addr
          {:error, _} -> System.halt(65)
        end
      '';
      passAsFile = [ "code" ];
    } ''elixir "$codePath" >"$out"'');

  format = pkgs.formats.elixirConf { elixir = cfg.package.elixirPackage; };
  configFile = format.generate "config.exs"
    (replaceSec
      (attrsets.updateManyAttrsByPath [{
        path = [ ":pleroma" "Pleroma.Web.Endpoint" "http" "ip" ];
        update = addr:
          if isAbsolutePath addr
            then format.lib.mkTuple
              [ (format.lib.mkAtom ":local") addr ]
            else format.lib.mkRaw (erlAddr addr);
      }] cfg.config));

  writeShell = { name, text, runtimeInputs ? [ ] }:
    pkgs.writeShellApplication { inherit name text runtimeInputs; } + "/bin/${name}";

  genScript = writeShell {
    name = "akkoma-gen-cookie";
    runtimeInputs = with pkgs; [ coreutils util-linux ];
    text = ''
      install -m 0400 \
        -o ${escapeShellArg cfg.user } \
        -g ${escapeShellArg cfg.group} \
        <(hexdump -n 16 -e '"%02x"' /dev/urandom) \
        "''${RUNTIME_DIRECTORY%%:*}/cookie"
    '';
  };

  copyScript = writeShell {
    name = "akkoma-copy-cookie";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      install -m 0400 \
        -o ${escapeShellArg cfg.user} \
        -g ${escapeShellArg cfg.group} \
        ${escapeShellArg cfg.dist.cookie._secret} \
        "''${RUNTIME_DIRECTORY%%:*}/cookie"
    '';
  };

  secretPaths = catAttrs "_secret" (collect isSecret cfg.config);

  vapidKeygen = pkgs.writeText "vapidKeygen.exs" ''
    [public_path, private_path] = System.argv()
    {public_key, private_key} = :crypto.generate_key :ecdh, :prime256v1
    File.write! public_path, Base.url_encode64(public_key, padding: false)
    File.write! private_path, Base.url_encode64(private_key, padding: false)
  '';

  initSecretsScript = writeShell {
    name = "akkoma-init-secrets";
    runtimeInputs = with pkgs; [ coreutils cfg.package.elixirPackage ];
    text = let
      key-base = web.secret_key_base;
      jwt-signer = ex.":joken".":default_signer";
      signing-salt = web.signing_salt;
      liveview-salt = web.live_view.signing_salt;
      vapid-private = ex.":web_push_encryption".":vapid_details".private_key;
      vapid-public = ex.":web_push_encryption".":vapid_details".public_key;
    in ''
      secret() {
        # Generate default secret if non‐existent
        test -e "$2" || install -D -m 0600 <(tr -dc 'A-Za-z-._~' </dev/urandom | head -c "$1") "$2"
        if [ "$(stat --dereference --format='%s' "$2")" -lt "$1" ]; then
          echo "Secret '$2' is smaller than minimum size of $1 bytes." >&2
          exit 65
        fi
      }

      secret 64 ${escapeShellArg key-base._secret}
      secret 64 ${escapeShellArg jwt-signer._secret}
      secret 8 ${escapeShellArg signing-salt._secret}
      secret 8 ${escapeShellArg liveview-salt._secret}

      ${optionalString (isSecret vapid-public) ''
        { test -e ${escapeShellArg vapid-private._secret} && \
          test -e ${escapeShellArg vapid-public._secret}; } || \
            elixir ${escapeShellArgs [ vapidKeygen vapid-public._secret vapid-private._secret ]}
      ''}
    '';
  };

  configScript = writeShell {
    name = "akkoma-config";
    runtimeInputs = with pkgs; [ coreutils replace-secret ];
    text = ''
      cd "''${RUNTIME_DIRECTORY%%:*}"
      tmp="$(mktemp config.exs.XXXXXXXXXX)"
      trap 'rm -f "$tmp"' EXIT TERM

      cat ${escapeShellArg configFile} >"$tmp"
      ${concatMapStrings (file: ''
        replace-secret ${escapeShellArgs [ (sha256 file) file ]} "$tmp"
      '') secretPaths}

      chown ${escapeShellArg cfg.user}:${escapeShellArg cfg.group} "$tmp"
      chmod 0400 "$tmp"
      mv -f "$tmp" config.exs
    '';
  };

  pgpass = let
    esc = escape [ ":" ''\'' ];
  in if (cfg.initDb.password != null)
    then pkgs.writeText "pgpass.conf" ''
      *:*:*${esc cfg.initDb.username}:${esc (sha256 cfg.initDb.password._secret)}
    ''
    else null;

  escapeSqlId = x: ''"${replaceStrings [ ''"'' ] [ ''""'' ] x}"'';
  escapeSqlStr = x: "'${replaceStrings [ "'" ] [ "''" ] x}'";

  setupSql = pkgs.writeText "setup.psql" ''
    \set ON_ERROR_STOP on

    ALTER ROLE ${escapeSqlId db.username}
      LOGIN PASSWORD ${if db ? password
        then "${escapeSqlStr (sha256 db.password._secret)}"
        else "NULL"};

    ALTER DATABASE ${escapeSqlId db.database}
      OWNER TO ${escapeSqlId db.username};

    \connect ${escapeSqlId db.database}
    CREATE EXTENSION IF NOT EXISTS citext;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
  '';

  dbHost = if db ? socket_dir then db.socket_dir
    else if db ? socket then db.socket
      else if db ? hostname then db.hostname
        else null;

  initDbScript = writeShell {
    name = "akkoma-initdb";
    runtimeInputs = with pkgs; [ coreutils replace-secret config.services.postgresql.package ];
    text = ''
      pgpass="$(mktemp -t pgpass-XXXXXXXXXX.conf)"
      setupSql="$(mktemp -t setup-XXXXXXXXXX.psql)"
      trap 'rm -f "$pgpass $setupSql"' EXIT TERM

      ${optionalString (dbHost != null) ''
        export PGHOST=${escapeShellArg dbHost}
      ''}
      export PGUSER=${escapeShellArg cfg.initDb.username}
      ${optionalString (pgpass != null) ''
        cat ${escapeShellArg pgpass} >"$pgpass"
        replace-secret ${escapeShellArgs [
          (sha256 cfg.initDb.password._secret) cfg.initDb.password._secret ]} "$pgpass"
        export PGPASSFILE="$pgpass"
      ''}

      cat ${escapeShellArg setupSql} >"$setupSql"
      ${optionalString (db ? password) ''
        replace-secret ${escapeShellArgs [
         (sha256 db.password._secret) db.password._secret ]} "$setupSql"
      ''}

      # Create role if non‐existent
      psql -tAc "SELECT 1 FROM pg_roles
        WHERE rolname = "${escapeShellArg (escapeSqlStr db.username)} | grep -F -q 1 || \
        psql -tAc "CREATE ROLE "${escapeShellArg (escapeSqlId db.username)}

      # Create database if non‐existent
      psql -tAc "SELECT 1 FROM pg_database
        WHERE datname = "${escapeShellArg (escapeSqlStr db.database)} | grep -F -q 1 || \
        psql -tAc "CREATE DATABASE "${escapeShellArg (escapeSqlId db.database)}"
          OWNER "${escapeShellArg (escapeSqlId db.username)}"
          TEMPLATE template0
          ENCODING 'utf8'
          LOCALE 'C'"

      psql -f "$setupSql"
    '';
  };

  envWrapper = let
    script = writeShell {
      name = "akkoma-env";
      text = ''
        cd "${cfg.package}"

        RUNTIME_DIRECTORY="''${RUNTIME_DIRECTORY:-/run/akkoma}"
        AKKOMA_CONFIG_PATH="''${RUNTIME_DIRECTORY%%:*}/config.exs" \
        ERL_EPMD_ADDRESS="${cfg.dist.address}" \
        ERL_EPMD_PORT="${toString cfg.dist.epmdPort}" \
        ERL_FLAGS=${lib.escapeShellArg (lib.escapeShellArgs ([
          "-kernel" "inet_dist_use_interface" (erlAddr cfg.dist.address)
          "-kernel" "inet_dist_listen_min" (toString cfg.dist.portMin)
          "-kernel" "inet_dist_listen_max" (toString cfg.dist.portMax)
        ] ++ cfg.dist.extraFlags))} \
        RELEASE_COOKIE="$(<"''${RUNTIME_DIRECTORY%%:*}/cookie")" \
        RELEASE_NAME="akkoma" \
          exec "${cfg.package}/bin/$(basename "$0")" "$@"
      '';
    };
  in pkgs.runCommandLocal "akkoma-env" { } ''
    mkdir -p "$out/bin"

    ln -r -s ${escapeShellArg script} "$out/bin/pleroma"
    ln -r -s ${escapeShellArg script} "$out/bin/pleroma_ctl"
  '';

  userWrapper = pkgs.writeShellApplication {
    name = "pleroma_ctl";
    text = ''
      if [ "''${1-}" == "update" ]; then
        echo "OTP releases are not supported on NixOS." >&2
        exit 64
      fi

      exec sudo -u ${escapeShellArg cfg.user} \
        "${envWrapper}/bin/pleroma_ctl" "$@"
    '';
  };

  socketScript = if isAbsolutePath web.http.ip
    then writeShell {
      name = "akkoma-socket";
      runtimeInputs = with pkgs; [ coreutils inotify-tools ];
      text = ''
        coproc {
          inotifywait -q -m -e create ${escapeShellArg (dirOf web.http.ip)}
        }

        trap 'kill "$COPROC_PID"' EXIT TERM

        until test -S ${escapeShellArg web.http.ip}
          do read -r -u "''${COPROC[0]}"
        done

        chmod 0666 ${escapeShellArg web.http.ip}
      '';
    }
    else null;

  staticDir = ex.":pleroma".":instance".static_dir;
  uploadDir = ex.":pleroma".":instance".upload_dir;

  staticFiles = pkgs.runCommandLocal "akkoma-static" { } ''
    ${concatStringsSep "\n" (mapAttrsToList (key: val: ''
      mkdir -p $out/frontends/${escapeShellArg val.name}/
      ln -s ${escapeShellArg val.package} $out/frontends/${escapeShellArg val.name}/${escapeShellArg val.ref}
    '') cfg.frontends)}

    ${optionalString (cfg.extraStatic != null)
      (concatStringsSep "\n" (mapAttrsToList (key: val: ''
        mkdir -p "$out/$(dirname ${escapeShellArg key})"
        ln -s ${escapeShellArg val} $out/${escapeShellArg key}
      '') cfg.extraStatic))}
  '';
in {
  options = {
    services.akkoma = {
      enable = mkEnableOption "Akkoma";

      package = mkPackageOption pkgs "akkoma" { };

      user = mkOption {
        type = types.nonEmptyStr;
        default = "akkoma";
        description = "User account under which Akkoma runs.";
      };

      group = mkOption {
        type = types.nonEmptyStr;
        default = "akkoma";
        description = "Group account under which Akkoma runs.";
      };

      initDb = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to automatically initialise the database on startup. This will create a
            database role and database if they do not already exist, and (re)set the role password
            and the ownership of the database.

            This setting can be used safely even if the database already exists and contains data.

            The database settings are configured through
            [{option}`config.services.akkoma.config.":pleroma"."Pleroma.Repo"`](#opt-services.akkoma.config.__pleroma_._Pleroma.Repo_).

            If disabled, the database has to be set up manually:

            ```SQL
            CREATE ROLE akkoma LOGIN;

            CREATE DATABASE akkoma
              OWNER akkoma
              TEMPLATE template0
              ENCODING 'utf8'
              LOCALE 'C';

            \connect akkoma
            CREATE EXTENSION IF NOT EXISTS citext;
            CREATE EXTENSION IF NOT EXISTS pg_trgm;
            CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
            ```
          '';
        };

        username = mkOption {
          type = types.nonEmptyStr;
          default = config.services.postgresql.superUser;
          defaultText = literalExpression "config.services.postgresql.superUser";
          description = ''
            Name of the database user to initialise the database with.

            This user is required to have the `CREATEROLE` and `CREATEDB` capabilities.
          '';
        };

        password = mkOption {
          type = types.nullOr secret;
          default = null;
          description = ''
            Password of the database user to initialise the database with.

            If set to `null`, no password will be used.

            The attribute `_secret` should point to a file containing the secret.
          '';
        };
      };

      initSecrets = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to initialise non‐existent secrets with random values.

          If enabled, appropriate secrets for the following options will be created automatically
          if the files referenced in the `_secrets` attribute do not exist during startup.

          - {option}`config.":pleroma"."Pleroma.Web.Endpoint".secret_key_base`
          - {option}`config.":pleroma"."Pleroma.Web.Endpoint".signing_salt`
          - {option}`config.":pleroma"."Pleroma.Web.Endpoint".live_view.signing_salt`
          - {option}`config.":web_push_encryption".":vapid_details".private_key`
          - {option}`config.":web_push_encryption".":vapid_details".public_key`
          - {option}`config.":joken".":default_signer"`
        '';
      };

      installWrapper = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to install a wrapper around `pleroma_ctl` to simplify administration of the
          Akkoma instance.
        '';
      };

      extraPackages = mkOption {
        type = with types; listOf package;
        default = with pkgs; [ exiftool ffmpeg_5-headless graphicsmagick-imagemagick-compat ];
        defaultText = literalExpression "with pkgs; [ exiftool graphicsmagick-imagemagick-compat ffmpeg_5-headless ]";
        example = literalExpression "with pkgs; [ exiftool imagemagick ffmpeg_5-full ]";
        description = ''
          List of extra packages to include in the executable search path of the service unit.
          These are needed by various configurable components such as:

          - ExifTool for the `Pleroma.Upload.Filter.Exiftool` upload filter,
          - ImageMagick for still image previews in the media proxy as well as for the
            `Pleroma.Upload.Filters.Mogrify` upload filter, and
          - ffmpeg for video previews in the media proxy.
        '';
      };

      frontends = mkOption {
        description = "Akkoma frontends.";
        type = with types; attrsOf (submodule frontend);
        default = {
          primary = {
            package = pkgs.akkoma-frontends.akkoma-fe;
            name = "akkoma-fe";
            ref = "stable";
          };
          admin = {
            package = pkgs.akkoma-frontends.admin-fe;
            name = "admin-fe";
            ref = "stable";
          };
        };
        defaultText = literalExpression ''
          {
            primary = {
              package = pkgs.akkoma-frontends.akkoma-fe;
              name = "akkoma-fe";
              ref = "stable";
            };
            admin = {
              package = pkgs.akkoma-frontends.admin-fe;
              name = "admin-fe";
              ref = "stable";
            };
          }
        '';
      };

      extraStatic = mkOption {
        type = with types; nullOr (attrsOf package);
        description = ''
          Attribute set of extra packages to add to the static files directory.

          Do not add frontends here. These should be configured through
          [{option}`services.akkoma.frontends`](#opt-services.akkoma.frontends).
        '';
        default = null;
        example = literalExpression ''
          {
            "emoji/blobs.gg" = pkgs.akkoma-emoji.blobs_gg;
            "static/terms-of-service.html" = pkgs.writeText "terms-of-service.html" '''
              …
            ''';
            "favicon.png" = let
              rev = "697a8211b0f427a921e7935a35d14bb3e32d0a2c";
            in pkgs.stdenvNoCC.mkDerivation {
              name = "favicon.png";

              src = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/TilCreator/NixOwO/''${rev}/NixOwO_plain.svg";
                hash = "sha256-tWhHMfJ3Od58N9H5yOKPMfM56hYWSOnr/TGCBi8bo9E=";
              };

              nativeBuildInputs = with pkgs; [ librsvg ];

              dontUnpack = true;
              installPhase = '''
                rsvg-convert -o $out -w 96 -h 96 $src
              ''';
            };
          }
        '';
      };

      dist = {
        address = mkOption {
          type = ipAddress;
          default = "127.0.0.1";
          description = ''
            Listen address for Erlang distribution protocol and Port Mapper Daemon (epmd).
          '';
        };

        epmdPort = mkOption {
          type = types.port;
          default = 4369;
          description = "TCP port to bind Erlang Port Mapper Daemon to.";
        };

        extraFlags = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "Extra flags to pass to Erlang";
          example = [ "+sbwt" "none" "+sbwtdcpu" "none" "+sbwtdio" "none" ];
        };

        portMin = mkOption {
          type = types.port;
          default = 49152;
          description = "Lower bound for Erlang distribution protocol TCP port.";
        };

        portMax = mkOption {
          type = types.port;
          default = 65535;
          description = "Upper bound for Erlang distribution protocol TCP port.";
        };

        cookie = mkOption {
          type = types.nullOr secret;
          default = null;
          example = { _secret = "/var/lib/secrets/akkoma/releaseCookie"; };
          description = ''
            Erlang release cookie.

            If set to `null`, a temporary random cookie will be generated.
          '';
        };
      };

      config = mkOption {
        description = ''
          Configuration for Akkoma. The attributes are serialised to Elixir DSL.

          Refer to <https://docs.akkoma.dev/stable/configuration/cheatsheet/> for
          configuration options.

          Settings containing secret data should be set to an attribute set containing the
          attribute `_secret` - a string pointing to a file containing the value the option
          should be set to.
        '';
        type = types.submodule {
          freeformType = format.type;
          options = {
            ":pleroma" = {
              ":instance" = {
                name = mkOption {
                  type = types.nonEmptyStr;
                  description = "Instance name.";
                };

                email = mkOption {
                  type = types.nonEmptyStr;
                  description = "Instance administrator email.";
                };

                description = mkOption {
                  type = types.nonEmptyStr;
                  description = "Instance description.";
                };

                static_dir = mkOption {
                  type = types.path;
                  default = toString staticFiles;
                  defaultText = literalMD ''
                    Derivation gathering the following paths into a directory:

                    - [{option}`services.akkoma.frontends`](#opt-services.akkoma.frontends)
                    - [{option}`services.akkoma.extraStatic`](#opt-services.akkoma.extraStatic)
                  '';
                  description = ''
                    Directory of static files.

                    This directory can be built using a derivation, or it can be managed as mutable
                    state by setting the option to an absolute path.
                  '';
                };

                upload_dir = mkOption {
                  type = absolutePath;
                  default = "/var/lib/akkoma/uploads";
                  description = ''
                    Directory where Akkoma will put uploaded files.
                  '';
                };
              };

              "Pleroma.Repo" = mkOption {
                type = elixirValue;
                default = {
                  adapter = format.lib.mkRaw "Ecto.Adapters.Postgres";
                  socket_dir = "/run/postgresql";
                  username = cfg.user;
                  database = "akkoma";
                };
                defaultText = literalExpression ''
                  {
                    adapter = (pkgs.formats.elixirConf { }).lib.mkRaw "Ecto.Adapters.Postgres";
                    socket_dir = "/run/postgresql";
                    username = config.services.akkoma.user;
                    database = "akkoma";
                  }
                '';
                description = ''
                  Database configuration.

                  Refer to
                  <https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html#module-connection-options>
                  for options.
                '';
              };

              "Pleroma.Web.Endpoint" = {
                url = {
                  host = mkOption {
                    type = types.nonEmptyStr;
                    default = config.networking.fqdn;
                    defaultText = literalExpression "config.networking.fqdn";
                    description = "Domain name of the instance.";
                  };

                  scheme = mkOption {
                    type = types.nonEmptyStr;
                    default = "https";
                    description = "URL scheme.";
                  };

                  port = mkOption {
                    type = types.port;
                    default = 443;
                    description = "External port number.";
                  };
                };

                http = {
                  ip = mkOption {
                    type = types.either absolutePath ipAddress;
                    default = "/run/akkoma/socket";
                    example = "::1";
                    description = ''
                      Listener IP address or Unix socket path.

                      The value is automatically converted to Elixir’s internal address
                      representation during serialisation.
                    '';
                  };

                  port = mkOption {
                    type = types.port;
                    default = if isAbsolutePath web.http.ip then 0 else 4000;
                    defaultText = literalExpression ''
                      if isAbsolutePath config.services.akkoma.config.:pleroma"."Pleroma.Web.Endpoint".http.ip
                        then 0
                        else 4000;
                    '';
                    description = ''
                      Listener port number.

                      Must be 0 if using a Unix socket.
                    '';
                  };
                };

                secret_key_base = mkOption {
                  type = secret;
                  default = { _secret = "/var/lib/secrets/akkoma/key-base"; };
                  description = ''
                    Secret key used as a base to generate further secrets for encrypting and
                    signing data.

                    The attribute `_secret` should point to a file containing the secret.

                    This key can generated can be generated as follows:

                    ```ShellSession
                    $ tr -dc 'A-Za-z-._~' </dev/urandom | head -c 64
                    ```
                  '';
                };

                live_view = {
                  signing_salt = mkOption {
                    type = secret;
                    default = { _secret = "/var/lib/secrets/akkoma/liveview-salt"; };
                    description = ''
                      LiveView signing salt.

                      The attribute `_secret` should point to a file containing the secret.

                      This salt can be generated as follows:

                      ```ShellSession
                      $ tr -dc 'A-Za-z0-9-._~' </dev/urandom | head -c 8
                      ```
                    '';
                  };
                };

                signing_salt = mkOption {
                  type = secret;
                  default = { _secret = "/var/lib/secrets/akkoma/signing-salt"; };
                  description = ''
                    Signing salt.

                    The attribute `_secret` should point to a file containing the secret.

                    This salt can be generated as follows:

                    ```ShellSession
                    $ tr -dc 'A-Za-z0-9-._~' </dev/urandom | head -c 8
                    ```
                  '';
                };
              };

              "Pleroma.Upload" = let
                httpConf = cfg.config.":pleroma"."Pleroma.Web.Endpoint".url;
              in {
                base_url = mkOption {
                    type = types.nonEmptyStr;
                    default = if lib.versionOlder config.system.stateVersion "24.05"
                              then "${httpConf.scheme}://${httpConf.host}:${builtins.toString httpConf.port}/media/"
                              else null;
                    defaultText = literalExpression ''
                      if lib.versionOlder config.system.stateVersion "24.05"
                      then "$\{httpConf.scheme}://$\{httpConf.host}:$\{builtins.toString httpConf.port}/media/"
                      else null;
                    '';
                    description = ''
                      Base path which uploads will be stored at.
                      Whilst this can just be set to a subdirectory of the main domain, it is now recommended to use a different subdomain.
                    '';
                };
              };

              ":frontends" = mkOption {
                type = elixirValue;
                default = mapAttrs
                  (key: val: format.lib.mkMap { name = val.name; ref = val.ref; })
                  cfg.frontends;
                defaultText = literalExpression ''
                  lib.mapAttrs (key: val:
                    (pkgs.formats.elixirConf { }).lib.mkMap { name = val.name; ref = val.ref; })
                    config.services.akkoma.frontends;
                '';
                description = ''
                  Frontend configuration.

                  Users should rely on the default value and prefer to configure frontends through
                  [{option}`config.services.akkoma.frontends`](#opt-services.akkoma.frontends).
                '';
              };


              ":media_proxy" = let
                httpConf = cfg.config.":pleroma"."Pleroma.Web.Endpoint".url;
              in {
                enabled = mkOption {
                    type = types.bool;
                    default = false;
                    defaultText = literalExpression "false";
                    description = ''
                      Whether to enable proxying of remote media through the instance's proxy.
                    '';
                };
                base_url = mkOption {
                    type = types.nullOr types.nonEmptyStr;
                    default = if lib.versionOlder config.system.stateVersion "24.05"
                              then "${httpConf.scheme}://${httpConf.host}:${builtins.toString httpConf.port}"
                              else null;
                    defaultText = literalExpression ''
                      if lib.versionOlder config.system.stateVersion "24.05"
                      then "$\{httpConf.scheme}://$\{httpConf.host}:$\{builtins.toString httpConf.port}"
                      else null;
                    '';
                    description = ''
                      Base path for the media proxy.
                      Whilst this can just be set to a subdirectory of the main domain, it is now recommended to use a different subdomain.
                    '';
                };
              };

            };

            ":web_push_encryption" = mkOption {
              default = { };
              description = ''
                Web Push Notifications configuration.

                The necessary key pair can be generated as follows:

                ```ShellSession
                $ nix-shell -p nodejs --run 'npx web-push generate-vapid-keys'
                ```
              '';
              type = types.submodule {
                freeformType = elixirValue;
                options = {
                  ":vapid_details" = {
                    subject = mkOption {
                      type = types.nonEmptyStr;
                      default = "mailto:${ex.":pleroma".":instance".email}";
                      defaultText = literalExpression ''
                        "mailto:''${config.services.akkoma.config.":pleroma".":instance".email}"
                      '';
                      description = "mailto URI for administrative contact.";
                    };

                    public_key = mkOption {
                      type = with types; either nonEmptyStr secret;
                      default = { _secret = "/var/lib/secrets/akkoma/vapid-public"; };
                      description = "base64-encoded public ECDH key.";
                    };

                    private_key = mkOption {
                      type = secret;
                      default = { _secret = "/var/lib/secrets/akkoma/vapid-private"; };
                      description = ''
                        base64-encoded private ECDH key.

                        The attribute `_secret` should point to a file containing the secret.
                      '';
                    };
                  };
                };
              };
            };

            ":joken" = {
              ":default_signer" = mkOption {
                type = secret;
                default = { _secret = "/var/lib/secrets/akkoma/jwt-signer"; };
                description = ''
                  JWT signing secret.

                  The attribute `_secret` should point to a file containing the secret.

                  This secret can be generated as follows:

                  ```ShellSession
                  $ tr -dc 'A-Za-z0-9-._~' </dev/urandom | head -c 64
                  ```
                '';
              };
            };

            ":logger" = {
              ":backends" = mkOption {
                type = types.listOf elixirValue;
                visible = false;
                default = with format.lib; [
                  (mkTuple [ (mkRaw "ExSyslogger") (mkAtom ":ex_syslogger") ])
                ];
              };

              ":ex_syslogger" = {
                ident = mkOption {
                  type = types.str;
                  visible = false;
                  default = "akkoma";
                };

                level = mkOption {
                  type = types.nonEmptyStr;
                  apply = format.lib.mkAtom;
                  default = ":info";
                  example = ":warning";
                  description = ''
                    Log level.

                    Refer to
                    <https://hexdocs.pm/logger/Logger.html#module-levels>
                    for options.
                  '';
                };
              };
            };

            ":tzdata" = {
              ":data_dir" = mkOption {
                type = elixirValue;
                internal = true;
                default = format.lib.mkRaw ''
                  Path.join(System.fetch_env!("CACHE_DIRECTORY"), "tzdata")
                '';
              };
            };
          };
        };
      };

      nginx = mkOption {
        type = with types; nullOr (submodule
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }));
        default = null;
        description = ''
          Extra configuration for the nginx virtual host of Akkoma.

          If set to `null`, no virtual host will be added to the nginx configuration.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = optionals (cfg.config.":pleroma".":media_proxy".enabled && cfg.config.":pleroma".":media_proxy".base_url == null) [''
      `services.akkoma.config.":pleroma".":media_proxy".base_url` must be set when the media proxy is enabled.
    ''];
    warnings = optionals (with config.security; cfg.installWrapper && (!sudo.enable) && (!sudo-rs.enable)) [''
      The pleroma_ctl wrapper enabled by the installWrapper option relies on
      sudo, which appears to have been disabled through security.sudo.enable.
    ''];

    users = {
      users."${cfg.user}" = {
        description = "Akkoma user";
        group = cfg.group;
        isSystemUser = true;
      };
      groups."${cfg.group}" = { };
    };

    # Confinement of the main service unit requires separation of the
    # configuration generation into a separate unit to permit access to secrets
    # residing outside of the chroot.
    systemd.services.akkoma-config = {
      description = "Akkoma social network configuration";
      reloadTriggers = [ configFile ] ++ secretPaths;

      unitConfig.PropagatesReloadTo = [ "akkoma.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";

        RuntimeDirectory = mkBefore "akkoma";

        ExecStart = mkMerge [
          (mkIf (cfg.dist.cookie == null) [ genScript ])
          (mkIf (cfg.dist.cookie != null) [ copyScript ])
          (mkIf cfg.initSecrets [ initSecretsScript ])
          [ configScript ]
        ];

        ExecReload = mkMerge [
          (mkIf cfg.initSecrets [ initSecretsScript ])
          [ configScript ]
        ];
      };
    };

    systemd.services.akkoma-initdb = mkIf cfg.initDb.enable {
      description = "Akkoma social network database setup";
      requires = [ "akkoma-config.service" ];
      requiredBy = [ "akkoma.service" ];
      after = [ "akkoma-config.service" "postgresql.service" ];
      before = [ "akkoma.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = mkIf (db ? socket_dir || db ? socket)
          cfg.initDb.username;
        RemainAfterExit = true;
        UMask = "0077";
        ExecStart = initDbScript;
        PrivateTmp = true;
      };
    };

    systemd.services.akkoma = let
      runtimeInputs = with pkgs; [ coreutils gawk gnused ] ++ cfg.extraPackages;
    in {
      description = "Akkoma social network";
      documentation = [ "https://docs.akkoma.dev/stable/" ];

      # This service depends on network-online.target and is sequenced after
      # it because it requires access to the Internet to function properly.
      bindsTo = [ "akkoma-config.service" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "akkoma-config.target"
        "network.target"
        "network-online.target"
        "postgresql.service"
      ];

      confinement.packages = mkIf isConfined runtimeInputs;
      path = runtimeInputs;

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";

        # The run‐time directory is preserved as it is managed by the akkoma-config.service unit.
        RuntimeDirectory = "akkoma";
        RuntimeDirectoryPreserve = true;

        CacheDirectory = "akkoma";

        BindPaths = [ "${uploadDir}:${uploadDir}:norbind" ];
        BindReadOnlyPaths = mkMerge [
          (mkIf (!isStorePath staticDir) [ "${staticDir}:${staticDir}:norbind" ])
          (mkIf isConfined (mkMerge [
            [ "/etc/hosts" "/etc/resolv.conf" ]
            (mkIf (isStorePath staticDir) (map (dir: "${dir}:${dir}:norbind")
              (splitString "\n" (readFile ((pkgs.closureInfo { rootPaths = staticDir; }) + "/store-paths")))))
            (mkIf (db ? socket_dir) [ "${db.socket_dir}:${db.socket_dir}:norbind" ])
            (mkIf (db ? socket) [ "${db.socket}:${db.socket}:norbind" ])
          ]))
        ];

        ExecStartPre = "${envWrapper}/bin/pleroma_ctl migrate";
        ExecStart = "${envWrapper}/bin/pleroma start";
        ExecStartPost = socketScript;
        ExecStop = "${envWrapper}/bin/pleroma stop";
        ExecStopPost = mkIf (isAbsolutePath web.http.ip)
          "${pkgs.coreutils}/bin/rm -f '${web.http.ip}'";

        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;

        CapabilityBoundingSet = mkIf
          (any (port: port > 0 && port < 1024)
            [ web.http.port cfg.dist.epmdPort cfg.dist.portMin ])
          [ "CAP_NET_BIND_SERVICE" ];

        NoNewPrivileges = true;
        SystemCallFilter = [ "@system-service" "~@privileged" "@chown" ];
        SystemCallArchitectures = "native";

        DeviceAllow = null;
        DevicePolicy = "closed";

        # SMTP adapter uses dynamic port 0 binding, which is incompatible with bind address filtering
        SocketBindAllow = mkIf (!hasSmtp) (mkMerge [
          [ "tcp:${toString cfg.dist.epmdPort}" "tcp:${toString cfg.dist.portMin}-${toString cfg.dist.portMax}" ]
          (mkIf (web.http.port != 0) [ "tcp:${toString web.http.port}" ])
        ]);
        SocketBindDeny = mkIf (!hasSmtp) "any";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${uploadDir}  0700 ${cfg.user} ${cfg.group} - -"
      "Z ${uploadDir} ~0700 ${cfg.user} ${cfg.group} - -"
    ];

    environment.systemPackages = mkIf (cfg.installWrapper) [ userWrapper ];

    services.nginx.virtualHosts = mkIf (cfg.nginx != null) {
      ${web.url.host} = mkMerge [ cfg.nginx {
        locations."/" = {
          proxyPass =
            if isAbsolutePath web.http.ip
              then "http://unix:${web.http.ip}"
              else if hasInfix ":" web.http.ip
                then "http://[${web.http.ip}]:${toString web.http.port}"
                else "http://${web.http.ip}:${toString web.http.port}";

          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }];
    };
  };

  meta.maintainers = with maintainers; [ mvs ];
  meta.doc = ./akkoma.md;
}
