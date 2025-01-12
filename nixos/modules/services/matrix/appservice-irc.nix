{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.matrix-appservice-irc;

  pkg = pkgs.matrix-appservice-irc;
  bin = "${pkg}/bin/matrix-appservice-irc";

  jsonType = (pkgs.formats.json { }).type;

  configFile =
    pkgs.runCommand "matrix-appservice-irc.yml"
      {
        # Because this program will be run at build time, we need `nativeBuildInputs`
        nativeBuildInputs = [
          (pkgs.python3.withPackages (ps: [ ps.jsonschema ]))
          pkgs.remarshal
        ];
        preferLocalBuild = true;

        config = builtins.toJSON cfg.settings;
        passAsFile = [ "config" ];
      }
      ''
        # The schema is given as yaml, we need to convert it to json
        remarshal --if yaml --of json -i ${pkg}/config.schema.yml -o config.schema.json
        python -m jsonschema config.schema.json -i $configPath
        cp "$configPath" "$out"
      '';
  registrationFile = "/var/lib/matrix-appservice-irc/registration.yml";
in
{
  options.services.matrix-appservice-irc = with lib.types; {
    enable = lib.mkEnableOption "the Matrix/IRC bridge";

    port = lib.mkOption {
      type = port;
      description = "The port to listen on";
      default = 8009;
    };

    needBindingCap = lib.mkOption {
      type = bool;
      description = "Whether the daemon needs to bind to ports below 1024 (e.g. for the ident service)";
      default = false;
    };

    passwordEncryptionKeyLength = lib.mkOption {
      type = ints.unsigned;
      description = "Length of the key to encrypt IRC passwords with";
      default = 4096;
      example = 8192;
    };

    registrationUrl = lib.mkOption {
      type = str;
      description = ''
        The URL where the application service is listening for homeserver requests,
        from the Matrix homeserver perspective.
      '';
      example = "http://localhost:8009";
    };

    localpart = lib.mkOption {
      type = str;
      description = "The user_id localpart to assign to the appservice";
      default = "appservice-irc";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for the appservice, see
        <https://github.com/matrix-org/matrix-appservice-irc/blob/${pkgs.matrix-appservice-irc.version}/config.sample.yaml>
        for supported values
      '';
      default = { };
      type = submodule {
        freeformType = jsonType;

        options = {
          homeserver = lib.mkOption {
            description = "Homeserver configuration";
            default = { };
            type = submodule {
              freeformType = jsonType;

              options = {
                url = lib.mkOption {
                  type = str;
                  description = "The URL to the home server for client-server API calls";
                };

                domain = lib.mkOption {
                  type = str;
                  description = ''
                    The 'domain' part for user IDs on this home server. Usually
                    (but not always) is the "domain name" part of the homeserver URL.
                  '';
                };
              };
            };
          };

          database = lib.mkOption {
            default = { };
            description = "Configuration for the database";
            type = submodule {
              freeformType = jsonType;

              options = {
                engine = lib.mkOption {
                  type = str;
                  description = "Which database engine to use";
                  default = "nedb";
                  example = "postgres";
                };

                connectionString = lib.mkOption {
                  type = str;
                  description = "The database connection string";
                  default = "nedb://var/lib/matrix-appservice-irc/data";
                  example = "postgres://username:password@host:port/databasename";
                };
              };
            };
          };

          ircService = lib.mkOption {
            default = { };
            description = "IRC bridge configuration";
            type = submodule {
              freeformType = jsonType;

              options = {
                passwordEncryptionKeyPath = lib.mkOption {
                  type = str;
                  description = ''
                    Location of the key with which IRC passwords are encrypted
                    for storage. Will be generated on first run if not present.
                  '';
                  default = "/var/lib/matrix-appservice-irc/passkey.pem";
                };

                servers = lib.mkOption {
                  type = submodule { freeformType = jsonType; };
                  description = "IRC servers to connect to";
                };

                mediaProxy = {
                  signingKeyPath = lib.mkOption {
                    type = path;
                    default = "/var/lib/matrix-appservice-irc/media-signingkey.jwk";
                    description = ''
                      Path to the signing key file for authenticated media.
                    '';
                  };
                  ttlSeconds = lib.mkOption {
                    type = ints.unsigned;
                    default = 3600;
                    example = 0;
                    description = ''
                      Lifetime in seconds, that generated URLs stay valid.

                      Set the lifetime to 0 to prevent URLs from becoming invalid.
                    '';
                  };
                  bindPort = lib.mkOption {
                    type = port;
                    default = 11111;
                    description = ''
                      Port that the media proxy binds to.
                    '';
                  };
                  publicUrl = lib.mkOption {
                    type = str;
                    example = "https://matrix.example.com/media";
                    description = ''
                      URL under which the media proxy is publicly acccessible.
                    '';
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        if ! [ -f "${cfg.settings.ircService.mediaProxy.signingKeyPath}"]; then
          ${lib.getExe pkgs.nodejs} ${pkg}/lib/generate-signing-key.js > "${cfg.settings.ircService.mediaProxy.signingKeyPath}"
        fi
        # Allow synapse access to the registration
        if ${pkgs.getent}/bin/getent group matrix-synapse > /dev/null; then
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

        CapabilityBoundingSet = [ "CAP_CHOWN" ] ++ lib.optional (cfg.needBindingCap) "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = CapabilityBoundingSet;
        NoNewPrivileges = true;

        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        SystemCallFilter = [
          "@system-service @pkey"
          "~@privileged @resources"
          "@chown"
        ];
        SystemCallArchitectures = "native";
        # AF_UNIX is required to connect to a postgres socket.
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };
    };

    users.groups.matrix-appservice-irc = { };
    users.users.matrix-appservice-irc = {
      description = "Service user for the Matrix-IRC bridge";
      group = "matrix-appservice-irc";
      isSystemUser = true;
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
