{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.matrix-appservice-irc;

  pkg = pkgs.matrix-appservice-irc;
  bin = "${pkg}/bin/matrix-appservice-irc";

  jsonType = (pkgs.formats.json {}).type;

  configFile = pkgs.runCommand "matrix-appservice-irc.yml" {
    # Because this program will be run at build time, we need `nativeBuildInputs`
    nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.pyyaml ps.jsonschema ])) ];
    preferLocalBuild = true;

    config = builtins.toJSON cfg.settings;
    passAsFile = [ "config" ];
  } ''
    # The schema is given as yaml, we need to convert it to json
    python -c 'import json; import yaml; import sys; json.dump(yaml.safe_load(sys.stdin), sys.stdout)' \
      < ${pkg}/lib/node_modules/matrix-appservice-irc/config.schema.yml \
      > config.schema.json
    python -m jsonschema config.schema.json -i $configPath
    cp "$configPath" "$out"
  '';
  registrationFile = "/var/lib/matrix-appservice-irc/registration.yml";
in {
  options.services.matrix-appservice-irc = with types; {
    enable = mkEnableOption "the Matrix/IRC bridge";

    port = mkOption {
      type = port;
      description = lib.mdDoc "The port to listen on";
      default = 8009;
    };

    needBindingCap = mkOption {
      type = bool;
      description = lib.mdDoc "Whether the daemon needs to bind to ports below 1024 (e.g. for the ident service)";
      default = false;
    };

    passwordEncryptionKeyLength = mkOption {
      type = ints.unsigned;
      description = lib.mdDoc "Length of the key to encrypt IRC passwords with";
      default = 4096;
      example = 8192;
    };

    registrationUrl = mkOption {
      type = str;
      description = lib.mdDoc ''
        The URL where the application service is listening for homeserver requests,
        from the Matrix homeserver perspective.
      '';
      example = "http://localhost:8009";
    };

    localpart = mkOption {
      type = str;
      description = lib.mdDoc "The user_id localpart to assign to the appservice";
      default = "appservice-irc";
    };

    settings = mkOption {
      description = lib.mdDoc ''
        Configuration for the appservice, see
        <https://github.com/matrix-org/matrix-appservice-irc/blob/${pkgs.matrix-appservice-irc.version}/config.sample.yaml>
        for supported values
      '';
      default = {};
      type = submodule {
        freeformType = jsonType;

        options = {
          homeserver = mkOption {
            description = lib.mdDoc "Homeserver configuration";
            default = {};
            type = submodule {
              freeformType = jsonType;

              options = {
                url = mkOption {
                  type = str;
                  description = lib.mdDoc "The URL to the home server for client-server API calls";
                };

                domain = mkOption {
                  type = str;
                  description = lib.mdDoc ''
                    The 'domain' part for user IDs on this home server. Usually
                    (but not always) is the "domain name" part of the homeserver URL.
                  '';
                };
              };
            };
          };

          database = mkOption {
            default = {};
            description = lib.mdDoc "Configuration for the database";
            type = submodule {
              freeformType = jsonType;

              options = {
                engine = mkOption {
                  type = str;
                  description = lib.mdDoc "Which database engine to use";
                  default = "nedb";
                  example = "postgres";
                };

                connectionString = mkOption {
                  type = str;
                  description = lib.mdDoc "The database connection string";
                  default = "nedb://var/lib/matrix-appservice-irc/data";
                  example = "postgres://username:password@host:port/databasename";
                };
              };
            };
          };

          ircService = mkOption {
            default = {};
            description = lib.mdDoc "IRC bridge configuration";
            type = submodule {
              freeformType = jsonType;

              options = {
                passwordEncryptionKeyPath = mkOption {
                  type = str;
                  description = lib.mdDoc ''
                    Location of the key with which IRC passwords are encrypted
                    for storage. Will be generated on first run if not present.
                  '';
                  default = "/var/lib/matrix-appservice-irc/passkey.pem";
                };

                servers = mkOption {
                  type = submodule { freeformType = jsonType; };
                  description = lib.mdDoc "IRC servers to connect to";
                };
              };
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.matrix-appservice-irc = {
      description = "Matrix-IRC bridge";
      before = [ "matrix-synapse.service" ]; # So the registration can be used by Synapse
      after = lib.optionals (cfg.settings.database.engine == "postgres") [
        "postgresql.service"
      ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        umask 077
        # Generate key for crypting passwords
        if ! [ -f "${cfg.settings.ircService.passwordEncryptionKeyPath}" ]; then
          ${pkgs.openssl}/bin/openssl genpkey \
              -out "${cfg.settings.ircService.passwordEncryptionKeyPath}" \
              -outform PEM \
              -algorithm RSA \
              -pkeyopt "rsa_keygen_bits:${toString cfg.passwordEncryptionKeyLength}"
        fi
        # Generate registration file
        if ! [ -f "${registrationFile}" ]; then
          # The easy case: the file has not been generated yet
          ${bin} --generate-registration --file ${registrationFile} --config ${configFile} --url ${cfg.registrationUrl} --localpart ${cfg.localpart}
        else
          # The tricky case: we already have a generation file. Because the NixOS configuration might have changed, we need to
          # regenerate it. But this would give the service a new random ID and tokens, so we need to back up and restore them.
          # 1. Backup
          id=$(grep "^id:.*$" ${registrationFile})
          hs_token=$(grep "^hs_token:.*$" ${registrationFile})
          as_token=$(grep "^as_token:.*$" ${registrationFile})
          # 2. Regenerate
          ${bin} --generate-registration --file ${registrationFile} --config ${configFile} --url ${cfg.registrationUrl} --localpart ${cfg.localpart}
          # 3. Restore
          sed -i "s/^id:.*$/$id/g" ${registrationFile}
          sed -i "s/^hs_token:.*$/$hs_token/g" ${registrationFile}
          sed -i "s/^as_token:.*$/$as_token/g" ${registrationFile}
        fi
        # Allow synapse access to the registration
        if ${getBin pkgs.glibc}/bin/getent group matrix-synapse > /dev/null; then
          chgrp matrix-synapse ${registrationFile}
          chmod g+r ${registrationFile}
        fi
      '';

      serviceConfig = rec {
        Type = "simple";
        ExecStart = "${bin} --config ${configFile} --file ${registrationFile} --port ${toString cfg.port}";

        ProtectHome = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        StateDirectory = "matrix-appservice-irc";
        StateDirectoryMode = "755";

        User = "matrix-appservice-irc";
        Group = "matrix-appservice-irc";

        CapabilityBoundingSet = [ "CAP_CHOWN" ] ++ optional (cfg.needBindingCap) "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = CapabilityBoundingSet;
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        SystemCallFilter = "~@aio @clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @setuid @swap";
        SystemCallArchitectures = "native";
        # AF_UNIX is required to connect to a postgres socket.
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };
    };

    users.groups.matrix-appservice-irc = {};
    users.users.matrix-appservice-irc = {
      description = "Service user for the Matrix-IRC bridge";
      group = "matrix-appservice-irc";
      isSystemUser = true;
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
