{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.mautrix;
  serviceSubmodule = types.submodule ({ name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      settings = mkOption rec {
        # TODO: switch to types.config.json as prescribed by RFC42 once it's implemented
        type = types.attrs;
        apply = recursiveUpdate default;
        default = {
          appservice = rec {
            database = "sqlite:///${dataDir}/mautrix-facebook.db";
            database_opts = { };
            hostname = "0.0.0.0";
            port = 8080;
            address = "http://localhost:${toString port}";
          };

          bridge = {
            permissions."*" = "relaybot";
            relaybot.whitelist = [ ];
            double_puppet_server_map = { };
            login_shared_secret_map = { };
          };

          logging = {
            version = 1;

            formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

            handlers.console = {
              class = "logging.StreamHandler";
              formatter = "precise";
            };

            loggers = {
              mau.level = "INFO";
              telethon.level = "INFO";

              # prevent tokens from leaking in the logs:
              # https://github.com/tulir/mautrix-telegram/issues/351
              aiohttp.level = "WARNING";
            };

            # log to console/systemd instead of file
            root = {
              level = "INFO";
              handlers = [ "console" ];
            };
          };
        };
        example = literalExample ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "public-domain.tld";
            };

            appservice.public = {
              prefix = "/public";
              external = "https://public-appservice-address/public";
            };

            bridge.permissions = {
              "example.com" = "full";
              "@admin:example.com" = "admin";
            };
          }
        '';
        description = ''
          <filename>config.yaml</filename> configuration as a Nix attribute set.
          Configuration options should match those described in
          <link xlink:href="https://github.com/tulir/mautrix-facebook/blob/master/example-config.yaml">
          example-config.yaml</link>.
          </para>

          <para>
          Secret tokens should be specified using <option>environmentFile</option>
          instead of this world-readable attribute set.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing environment variables to be passed to the mautrix-facebook service,
          in which secret tokens can be specified securely by defining values for
          <literal>MAUTRIX_FACEBOOK_APPSERVICE_AS_TOKEN</literal>,
          <literal>MAUTRIX_FACEBOOK_APPSERVICE_HS_TOKEN</literal>,
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable
          "matrix-synapse.service";
        description = ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  });
in {
  options = {
    services.mautrix = {
      services = mkOption {
        type = types.attrsOf serviceSubmodule;
        default = {};
      };
    };
  };

  config = {
    systemd.services = (mapAttrs' (name: value: nameValuePair ("mautrix-${name}") ({
      description = "Mautrix service - ${$name}";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ value.serviceDependencies;
      after = [ "network-online.target" ] ++ value.serviceDependencies;

      preStart = ''
        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-facebook}/bin/mautrix-facebook \
            --generate-registration \
            --base-config='${pkgs.mautrix-facebook}/${pkgs.mautrix-facebook.pythonModule.sitePackages}/mautrix_facebook/example-config.yaml' \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi

        # run automatic database init and migration scripts
        ${pkgs.mautrix-facebook.alembic}/bin/alembic -x config='${settingsFile}' upgrade head
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        # DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = pkgs.mautrix-facebook; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf dataDir;
        UMask = 27;
        EnvironmentFile = value.environmentFile;

        ExecStart = ''
          ${pkgs.mautrix-facebook}/bin/mautrix-facebook \
            --no-update \
            --config='${settingsFile}'
        '';
      };
    })) cfg.services );
  };

  meta.maintainers = with maintainers; [ eyJhb ];
}
