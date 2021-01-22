{ config, pkgs, lib, ... }:

with lib;

let
  # generators
  genSettingsFile = name: settings: pkgs.writeText "mautrix-${name}-settings.json" (builtins.toJSON settings);

  cfg = config.services.mautrix;
  # TODO(eyJhb) removed config
  serviceSubmodule = let
    globalCfg = config;
  in types.submodule ({ name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      package = mkOption {
        type = types.package;
      };

      datadir = mkOption {
        type = types.str;
        default = "/var/lib/mautrix-${name}";
      };

      envPrefix = mkOption {
        type = types.str;
        default = "MAUTRIX_${toUpper name}_";
        description = "Prefix to use when setting as_token and hs_token";
      };

      settings = mkOption rec {
        # TODO: switch to types.config.json as prescribed by RFC42 once it's implemented
        type = types.attrs;
        apply = recursiveUpdate default;
        default = {
          appservice = rec {
            database = "sqlite:///${config.datadir}/mautrix-facebook.db";
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
        default = optional globalCfg.services.matrix-synapse.enable
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

      registrationDir = mkOption {
        type = types.str;
        default = "/var/lib/mautrix-registration";
        description = "";
      };

      registrationUser = mkOption {
        type = types.str;
        default = "matrix-synapse";
      };
      registrationGroup = mkOption {
        type = types.str;
        default = "matrix-synapse";
      };
    };
  };

  config = {
    systemd.services = (mapAttrs' (name: value: nameValuePair ("mautrix-${name}") ({
      description = "Mautrix service - ${name}";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ value.serviceDependencies;
      after = [ "network-online.target" ] ++ value.serviceDependencies;

      path = [ pkgs.diffutils ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = pkgs.mautrix-facebook; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf value.datadir;
        UMask = 27;
        EnvironmentFile = value.environmentFile;

        ExecStartPre = "+"+(let 
            registrationOutFile = "${cfg.registrationDir}/${name}.yml";
            registrationFile = "${value.datadir}/registration.yml";
          in pkgs.writeShellScript "mautrix-${name}-execstartpre" ''
          # generate the appservice's registration file if absent
          if [ ! -f '${registrationFile}' ]; then
            ${value.package}/bin/${value.package.pname} \
              --generate-registration \
              --base-config='${value.package}/${value.package.pythonModule.sitePackages}/mautrix_facebook/example-config.yaml' \
              --config='${genSettingsFile name value.settings}' \
              --no-update \
              --registration='${registrationFile}'
          fi

          # if the file does not exists, or the files do not match, copy it over and chown it
          if [ ! -f '${registrationOutFile}' ] || ! (cmp --silent '${registrationFile}' '${registrationOutFile}'); then
            # ensure that dir exists
            if [ ! -d '${cfg.registrationDir}' ]; then
              mkdir -p '${cfg.registrationDir}'
              chown ${cfg.registrationUser}:${cfg.registrationGroup} '${cfg.registrationDir}'
            fi

            # copy it to the registrationdir and chown to correct user
            cp '${registrationFile}' '${registrationOutFile}'
            chown ${cfg.registrationUser}:${cfg.registrationGroup} '${registrationOutFile}'
          fi
              
          # run automatic database init and migration scripts
          ${value.package.alembic}/bin/alembic -x config='${genSettingsFile name value.settings}' upgrade head
        '');

        ExecStart = ''
          ${value.package}/bin/${value.package.pname} \
            --no-update \
            --config='${genSettingsFile name value.settings}'
        '';
      };
    })) cfg.services );
  };

  meta.maintainers = with maintainers; [ eyJhb ];
}

