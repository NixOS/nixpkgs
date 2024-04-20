{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.mobilizon;

  user = "mobilizon";
  group = "mobilizon";

  settingsFormat = pkgs.formats.elixirConf { elixir = cfg.package.elixirPackage; };

  configFile = settingsFormat.generate "mobilizon-config.exs" cfg.settings;

  # Make a package containing launchers with the correct envirenment, instead of
  # setting it with systemd services, so that the user can also use them without
  # troubles
  launchers = pkgs.stdenv.mkDerivation rec {
    pname = "${cfg.package.pname}-launchers";
    inherit (cfg.package) version;

    src = cfg.package;

    nativeBuildInputs = with pkgs; [ makeWrapper ];

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin

      makeWrapper \
        $src/bin/mobilizon \
        $out/bin/mobilizon \
        --run '. ${secretEnvFile}' \
        --set MOBILIZON_CONFIG_PATH "${configFile}" \
        --set-default RELEASE_TMP "/tmp"

      makeWrapper \
        $src/bin/mobilizon_ctl \
        $out/bin/mobilizon_ctl \
        --run '. ${secretEnvFile}' \
        --set MOBILIZON_CONFIG_PATH "${configFile}" \
        --set-default RELEASE_TMP "/tmp"
    '';
  };

  repoSettings = cfg.settings.":mobilizon"."Mobilizon.Storage.Repo";
  instanceSettings = cfg.settings.":mobilizon".":instance";

  isLocalPostgres = repoSettings.socket_dir != null;

  dbUser = if repoSettings.username != null then repoSettings.username else "mobilizon";

  postgresql = config.services.postgresql.package;
  postgresqlSocketDir = "/var/run/postgresql";

  secretEnvFile = "/var/lib/mobilizon/secret-env.sh";
in
{
  options = {
    services.mobilizon = {
      enable = mkEnableOption "Mobilizon federated organization and mobilization platform";

      nginx.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether an Nginx virtual host should be
          set up to serve Mobilizon.
        '';
      };

      package = mkPackageOption pkgs "mobilizon" { };

      settings = mkOption {
        type =
          let
            elixirTypes = settingsFormat.lib.types;
          in
          types.submodule {
            freeformType = settingsFormat.type;

            options = {
              ":mobilizon" = {

                "Mobilizon.Web.Endpoint" = {
                  url.host = mkOption {
                    type = elixirTypes.str;
                    defaultText = lib.literalMD ''
                      ''${settings.":mobilizon".":instance".hostname}
                    '';
                    description = ''
                      Your instance's hostname for generating URLs throughout the app
                    '';
                  };

                  http = {
                    port = mkOption {
                      type = elixirTypes.port;
                      default = 4000;
                      description = ''
                        The port to run the server
                      '';
                    };
                    ip = mkOption {
                      type = elixirTypes.tuple;
                      default = settingsFormat.lib.mkTuple [ 0 0 0 0 0 0 0 1 ];
                      description = ''
                        The IP address to listen on. Defaults to [::1] notated as a byte tuple.
                      '';
                    };
                  };

                  has_reverse_proxy = mkOption {
                    type = elixirTypes.bool;
                    default = true;
                    description = ''
                      Whether you use a reverse proxy
                    '';
                  };
                };

                ":instance" = {
                  name = mkOption {
                    type = elixirTypes.str;
                    description = ''
                      The fallback instance name if not configured into the admin UI
                    '';
                  };

                  hostname = mkOption {
                    type = elixirTypes.str;
                    description = ''
                      Your instance's hostname
                    '';
                  };

                  email_from = mkOption {
                    type = elixirTypes.str;
                    defaultText = literalExpression ''
                      noreply@''${settings.":mobilizon".":instance".hostname}
                    '';
                    description = ''
                      The email for the From: header in emails
                    '';
                  };

                  email_reply_to = mkOption {
                    type = elixirTypes.str;
                    defaultText = literalExpression ''
                      ''${email_from}
                    '';
                    description = ''
                      The email for the Reply-To: header in emails
                    '';
                  };
                };

                "Mobilizon.Storage.Repo" = {
                  socket_dir = mkOption {
                    type = types.nullOr elixirTypes.str;
                    default = postgresqlSocketDir;
                    description = ''
                      Path to the postgres socket directory.

                      Set this to null if you want to connect to a remote database.

                      If non-null, the local PostgreSQL server will be configured with
                      the configured database, permissions, and required extensions.

                      If connecting to a remote database, please follow the
                      instructions on how to setup your database:
                      <https://docs.joinmobilizon.org/administration/install/release/#database-setup>
                    '';
                  };

                  username = mkOption {
                    type = types.nullOr elixirTypes.str;
                    default = user;
                    description = ''
                      User used to connect to the database
                    '';
                  };

                  database = mkOption {
                    type = types.nullOr elixirTypes.str;
                    default = "mobilizon_prod";
                    description = ''
                      Name of the database
                    '';
                  };
                };
              };
            };
          };
        default = { };

        description = ''
          Mobilizon Elixir documentation, see
          <https://docs.joinmobilizon.org/administration/configure/reference/>
          for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.nginx.enable -> (cfg.settings.":mobilizon"."Mobilizon.Web.Endpoint".http.ip == settingsFormat.lib.mkTuple [ 0 0 0 0 0 0 0 1 ]);
        message = "Setting the IP mobilizon listens on is only possible when the nginx config is not used, as it is hardcoded there.";
      }
    ];

    services.mobilizon.settings = {
      ":mobilizon" = {
        "Mobilizon.Web.Endpoint" = {
          server = true;
          url.host = mkDefault instanceSettings.hostname;
          secret_key_base =
            settingsFormat.lib.mkGetEnv { envVariable = "MOBILIZON_INSTANCE_SECRET"; };
        };

        "Mobilizon.Web.Auth.Guardian".secret_key =
          settingsFormat.lib.mkGetEnv { envVariable = "MOBILIZON_AUTH_SECRET"; };

        ":instance" = {
          registrations_open = mkDefault false;
          demo = mkDefault false;
          email_from = mkDefault "noreply@${instanceSettings.hostname}";
          email_reply_to = mkDefault instanceSettings.email_from;
        };

        "Mobilizon.Storage.Repo" = {
          # Forced by upstream since it uses PostgreSQL-specific extensions
          adapter = settingsFormat.lib.mkAtom "Ecto.Adapters.Postgres";
          pool_size = mkDefault 10;
        };
      };

      ":tzdata".":data_dir" = "/var/lib/mobilizon/tzdata/";
    };

    # This somewhat follows upstream's systemd service here:
    # https://framagit.org/framasoft/mobilizon/-/blob/master/support/systemd/mobilizon.service
    systemd.services.mobilizon = {
      description = "Mobilizon federated organization and mobilization platform";

      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        gawk
        imagemagick
        libwebp
        file

        # Optional:
        gifsicle
        jpegoptim
        optipng
        pngquant
      ];

      serviceConfig = {
        ExecStartPre = "${launchers}/bin/mobilizon_ctl migrate";
        ExecStart = "${launchers}/bin/mobilizon start";
        ExecStop = "${launchers}/bin/mobilizon stop";

        User = user;
        Group = group;

        StateDirectory = "mobilizon";

        Restart = "on-failure";

        PrivateTmp = true;
        ProtectSystem = "full";
        NoNewPrivileges = true;

        ReadWritePaths = mkIf isLocalPostgres postgresqlSocketDir;
      };
    };

    # Create the needed secrets before running Mobilizon, so that they are not
    # in the nix store
    #
    # Since some of these tasks are quite common for Elixir projects (COOKIE for
    # every BEAM project, Phoenix and Guardian are also quite common), this
    # service could be abstracted in the future, and used by other Elixir
    # projects.
    systemd.services.mobilizon-setup-secrets = {
      description = "Mobilizon setup secrets";
      before = [ "mobilizon.service" ];
      wantedBy = [ "mobilizon.service" ];

      script =
        let
          # Taken from here:
          # https://framagit.org/framasoft/mobilizon/-/blob/1.0.7/lib/mix/tasks/mobilizon/instance.ex#L132-133
          genSecret =
            "IO.puts(:crypto.strong_rand_bytes(64)" +
            "|> Base.encode64()" +
            "|> binary_part(0, 64))";

          # Taken from here:
          # https://github.com/elixir-lang/elixir/blob/v1.11.3/lib/mix/lib/mix/release.ex#L499
          genCookie = "IO.puts(Base.encode32(:crypto.strong_rand_bytes(32)))";

          evalElixir = str: ''
            ${cfg.package.elixirPackage}/bin/elixir --eval '${str}'
          '';
        in
        ''
          set -euxo pipefail

          if [ ! -f "${secretEnvFile}" ]; then
            install -m 600 /dev/null "${secretEnvFile}"
            cat > "${secretEnvFile}" <<EOF
          # This file was automatically generated by mobilizon-setup-secrets.service
          export MOBILIZON_AUTH_SECRET='$(${evalElixir genSecret})'
          export MOBILIZON_INSTANCE_SECRET='$(${evalElixir genSecret})'
          export RELEASE_COOKIE='$(${evalElixir genCookie})'
          EOF
          fi
        '';

      serviceConfig = {
        Type = "oneshot";
        User = user;
        Group = group;
        StateDirectory = "mobilizon";
      };
    };

    # Add the required PostgreSQL extensions to the local PostgreSQL server,
    # if local PostgreSQL is configured.
    systemd.services.mobilizon-postgresql = mkIf isLocalPostgres {
      description = "Mobilizon PostgreSQL setup";

      after = [ "postgresql.service" ];
      before = [ "mobilizon.service" "mobilizon-setup-secrets.service" ];
      wantedBy = [ "mobilizon.service" ];

      path = [ postgresql ];

      # Taken from here:
      # https://framagit.org/framasoft/mobilizon/-/blob/1.1.0/priv/templates/setup_db.eex
      # TODO(to maintainers of mobilizon): the owner database alteration is necessary
      # as PostgreSQL 15 changed their behaviors w.r.t. to privileges.
      # See https://github.com/NixOS/nixpkgs/issues/216989 to get rid
      # of that workaround.
      script =
        ''
          psql "${repoSettings.database}" -c "\
            CREATE EXTENSION IF NOT EXISTS postgis; \
            CREATE EXTENSION IF NOT EXISTS pg_trgm; \
            CREATE EXTENSION IF NOT EXISTS unaccent;"
          psql -tAc 'ALTER DATABASE "${repoSettings.database}" OWNER TO "${dbUser}";'

        '';

      serviceConfig = {
        Type = "oneshot";
        User = config.services.postgresql.superUser;
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/mobilizon/uploads/exports/csv 700 mobilizon mobilizon - -"
      "Z /var/lib/mobilizon 700 mobilizon mobilizon - -"
    ];

    services.postgresql = mkIf isLocalPostgres {
      enable = true;
      ensureDatabases = [ repoSettings.database ];
      ensureUsers = [
        {
          name = dbUser;
          # Given that `dbUser` is potentially arbitrarily custom, we will perform
          # manual fixups in mobilizon-postgres.
          # TODO(to maintainers of mobilizon): Feel free to simplify your setup by using `ensureDBOwnership`.
          ensureDBOwnership = false;
        }
      ];
      extraPlugins = ps: with ps; [ postgis ];
    };

    # Nginx config taken from support/nginx/mobilizon-release.conf
    services.nginx =
      let
        inherit (cfg.settings.":mobilizon".":instance") hostname;
        proxyPass = "http://[::1]:"
          + toString cfg.settings.":mobilizon"."Mobilizon.Web.Endpoint".http.port;
      in
      lib.mkIf cfg.nginx.enable {
        enable = true;
        virtualHosts."${hostname}" = {
          enableACME = lib.mkDefault true;
          forceSSL = lib.mkDefault true;
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
          locations."/" = {
            inherit proxyPass;
          };
          locations."~ ^/(js|css|img)" = {
            root = "${cfg.package}/lib/mobilizon-${cfg.package.version}/priv/static";
            extraConfig = ''
              etag off;
              access_log off;
              add_header Cache-Control "public, max-age=31536000, immutable";
            '';
          };
          locations."~ ^/(media|proxy)" = {
            inherit proxyPass;
            extraConfig = ''
              etag off;
              access_log off;
              add_header Cache-Control "public, max-age=31536000, immutable";
            '';
          };
        };
      };

    users.users.${user} = {
      description = "Mobilizon daemon user";
      group = group;
      isSystemUser = true;
    };

    users.groups.${group} = { };

    # So that we have the `mobilizon` and `mobilizon_ctl` commands.
    # The `mobilizon remote` command is useful for dropping a shell into the
    # running Mobilizon instance, and `mobilizon_ctl` is used for common
    # management tasks (e.g. adding users).
    environment.systemPackages = [ launchers ];
  };

  meta.maintainers = with lib.maintainers; [ minijackson erictapen ];
}
