{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dendrite;
  settingsFormat = pkgs.formats.yaml { };
  configurationYaml = settingsFormat.generate "dendrite.yaml" cfg.settings;
  workingDir = "/var/lib/dendrite";
in
{
  options.services.dendrite = {
    enable = lib.mkEnableOption "matrix.org dendrite";
    httpPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = 8008;
      description = ''
        The port to listen for HTTP requests on.
      '';
    };
    httpsPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = ''
        The port to listen for HTTPS requests on.
      '';
    };
    tlsCert = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/server.cert";
      default = null;
      description = ''
        The path to the TLS certificate.

        ```
          nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
        ```
      '';
    };
    tlsKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/server.key";
      default = null;
      description = ''
        The path to the TLS key.

        ```
          nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
        ```
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = "/var/lib/dendrite/registration_secret";
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
        Secrets may be passed to the service without adding them to the world-readable
        Nix store, by specifying placeholder variables as the option value in Nix and
        setting these variables accordingly in the environment file. Currently only used
        for the registration secret to allow secure registration when
        client_api.registration_disabled is true.

        ```
          # snippet of dendrite-related config
          services.dendrite.settings.client_api.registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
        ```

        ```
          # content of the environment file
          REGISTRATION_SHARED_SECRET=verysecretpassword
        ```

        Note that this file needs to be available on the host on which
        `dendrite` is running.
      '';
    };
    loadCredential = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "private_key:/path/to/my_private_key" ];
      description = ''
        This can be used to pass secrets to the systemd service without adding them to
        the nix store.
        To use the example setting, see the example of
        {option}`services.dendrite.settings.global.private_key`.
        See the LoadCredential section of systemd.exec manual for more information.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.global = {
          server_name = lib.mkOption {
            type = lib.types.str;
            example = "example.com";
            description = ''
              The domain name of the server, with optional explicit port.
              This is used by remote servers to connect to this server.
              This is also the last part of your UserID.
            '';
          };
          private_key = lib.mkOption {
            type = lib.types.either lib.types.path (lib.types.strMatching "^\\$CREDENTIALS_DIRECTORY/.+");
            example = "$CREDENTIALS_DIRECTORY/private_key";
            description = ''
              The path to the signing private key file, used to sign
              requests and events.

              ```
                nix-shell -p dendrite --command "generate-keys --private-key matrix_key.pem"
              ```
            '';
          };
          trusted_third_party_id_servers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = [ "matrix.org" ];
            default = [
              "matrix.org"
              "vector.im"
            ];
            description = ''
              Lists of domains that the server will trust as identity
              servers to verify third party identifiers such as phone
              numbers and email addresses
            '';
          };
        };
        options.app_service_api.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:federationapi.db";
            description = ''
              Database for the Appservice API.
            '';
          };
        };
        options.client_api = {
          registration_disabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to disable user registration to the server
              without the shared secret.
            '';
          };
        };
        options.federation_api.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:federationapi.db";
            description = ''
              Database for the Federation API.
            '';
          };
        };
        options.key_server.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:keyserver.db";
            description = ''
              Database for the Key Server (for end-to-end encryption).
            '';
          };
        };
        options.relay_api.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:relayapi.db";
            description = ''
              Database for the Relay Server.
            '';
          };
        };
        options.media_api = {
          database = {
            connection_string = lib.mkOption {
              type = lib.types.str;
              default = "file:mediaapi.db";
              description = ''
                Database for the Media API.
              '';
            };
          };
          base_path = lib.mkOption {
            type = lib.types.str;
            default = "${workingDir}/media_store";
            description = ''
              Storage path for uploaded media.
            '';
          };
        };
        options.room_server.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:roomserver.db";
            description = ''
              Database for the Room Server.
            '';
          };
        };
        options.sync_api.database = {
          connection_string = lib.mkOption {
            type = lib.types.str;
            default = "file:syncserver.db";
            description = ''
              Database for the Sync API.
            '';
          };
        };
        options.sync_api.search = {
          enabled = lib.mkEnableOption "Dendrite's full-text search engine";
          index_path = lib.mkOption {
            type = lib.types.str;
            default = "${workingDir}/searchindex";
            description = ''
              The path the search index will be created in.
            '';
          };
          language = lib.mkOption {
            type = lib.types.str;
            default = "en";
            description = ''
              The language most likely to be used on the server - used when indexing, to
              ensure the returned results match expectations. A full list of possible languages
              can be found at <https://github.com/blevesearch/bleve/tree/master/analysis/lang>
            '';
          };
        };
        options.user_api = {
          account_database = {
            connection_string = lib.mkOption {
              type = lib.types.str;
              default = "file:userapi_accounts.db";
              description = ''
                Database for the User API, accounts.
              '';
            };
          };
          device_database = {
            connection_string = lib.mkOption {
              type = lib.types.str;
              default = "file:userapi_devices.db";
              description = ''
                Database for the User API, devices.
              '';
            };
          };
        };
        options.mscs = {
          database = {
            connection_string = lib.mkOption {
              type = lib.types.str;
              default = "file:mscs.db";
              description = ''
                Database for exerimental MSC's.
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for dendrite, see:
        <https://github.com/matrix-org/dendrite/blob/main/dendrite-sample.yaml>
        for available options with which to populate settings.
      '';
    };
    openRegistration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Allow open registration without secondary verification (reCAPTCHA).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.httpsPort != null -> (cfg.tlsCert != null && cfg.tlsKey != null);
        message = ''
          If Dendrite is configured to use https, tlsCert and tlsKey must be provided.

          nix-shell -p dendrite --command "generate-keys --tls-cert server.crt --tls-key server.key"
        '';
      }
      {
        assertion = !(cfg.settings.sync_api.search ? enable);
        message = ''
          The `services.dendrite.settings.sync_api.search.enable` option
          has been renamed to `services.dendrite.settings.sync_api.search.enabled`.
        '';
      }
    ];

    systemd.services.dendrite = {
      description = "Dendrite Matrix homeserver";
      after = [
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "dendrite";
        WorkingDirectory = workingDir;
        RuntimeDirectory = "dendrite";
        RuntimeDirectoryMode = "0700";
        LimitNOFILE = 65535;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = cfg.loadCredential;
        ExecStartPre = [
          ''
            ${pkgs.envsubst}/bin/envsubst \
              -i ${configurationYaml} \
              -o /run/dendrite/dendrite.yaml
          ''
        ];
        ExecStart = lib.strings.concatStringsSep " " (
          [
            "${pkgs.dendrite}/bin/dendrite"
            "--config /run/dendrite/dendrite.yaml"
          ]
          ++ lib.optionals (cfg.httpPort != null) [
            "--http-bind-address :${builtins.toString cfg.httpPort}"
          ]
          ++ lib.optionals (cfg.httpsPort != null) [
            "--https-bind-address :${builtins.toString cfg.httpsPort}"
            "--tls-cert ${cfg.tlsCert}"
            "--tls-key ${cfg.tlsKey}"
          ]
          ++ lib.optionals cfg.openRegistration [
            "--really-enable-open-registration"
          ]
        );
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };
  meta.maintainers = lib.teams.matrix.members;
}
