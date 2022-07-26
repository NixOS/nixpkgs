{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.home-assistant;
  format = pkgs.formats.yaml {};

  # Render config attribute sets to YAML
  # Values that are null will be filtered from the output, so this is one way to have optional
  # options shown in settings.
  # We post-process the result to add support for YAML functions, like secrets or includes, see e.g.
  # https://www.home-assistant.io/docs/configuration/secrets/
  filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! elem v [ null ])) cfg.config or {};
  configFile = pkgs.runCommand "configuration.yaml" { preferLocalBuild = true; } ''
    cp ${format.generate "configuration.yaml" filteredConfig} $out
    sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
  '';
  lovelaceConfig = cfg.lovelaceConfig or {};
  lovelaceConfigFile = format.generate "ui-lovelace.yaml" lovelaceConfig;

  # Components advertised by the home-assistant package
  availableComponents = cfg.package.availableComponents;

  # Components that were added by overriding the package
  explicitComponents = cfg.package.extraComponents;
  useExplicitComponent = component: elem component explicitComponents;

  # Given a component "platform", looks up whether it is used in the config
  # as `platform = "platform";`.
  #
  # For example, the component mqtt.sensor is used as follows:
  # config.sensor = [ {
  #   platform = "mqtt";
  #   ...
  # } ];
  usedPlatforms = config:
    if isAttrs config then
      optional (config ? platform) config.platform
      ++ concatMap usedPlatforms (attrValues config)
    else if isList config then
      concatMap usedPlatforms config
    else [ ];

  useComponentPlatform = component: elem component (usedPlatforms cfg.config);

  # Returns whether component is used in config, explicitly passed into package or
  # configured in the module.
  useComponent = component:
    hasAttrByPath (splitString "." component) cfg.config
    || useComponentPlatform component
    || useExplicitComponent component
    || builtins.elem component cfg.extraComponents;

  # Final list of components passed into the package to include required dependencies
  extraComponents = filter useComponent availableComponents;

  package = (cfg.package.override (oldArgs: {
    # Respect overrides that already exist in the passed package and
    # concat it with values passed via the module.
    extraComponents = oldArgs.extraComponents or [] ++ extraComponents;
    extraPackages = ps: (oldArgs.extraPackages or (_: []) ps) ++ (cfg.extraPackages ps);
  }));
in {
  imports = [
    # Migrations in NixOS 22.05
    (mkRemovedOptionModule [ "services" "home-assistant" "applyDefaultConfig" ] "The default config was migrated into services.home-assistant.config")
    (mkRemovedOptionModule [ "services" "home-assistant" "autoExtraComponents" ] "Components are now parsed from services.home-assistant.config unconditionally")
    (mkRenamedOptionModule [ "services" "home-assistant" "port" ] [ "services" "home-assistant" "config" "http" "server_port" ])
  ];

  meta = {
    buildDocsInSandbox = false;
    maintainers = teams.home-assistant.members;
  };

  options.services.home-assistant = {
    # Running home-assistant on NixOS is considered an installation method that is unsupported by the upstream project.
    # https://github.com/home-assistant/architecture/blob/master/adr/0012-define-supported-installation-method.md#decision
    enable = mkEnableOption "Home Assistant. Please note that this installation method is unsupported upstream";

    configDir = mkOption {
      default = "/var/lib/hass";
      type = types.path;
      description = "The config directory, where your <filename>configuration.yaml</filename> is located.";
    };

    extraComponents = mkOption {
      type = types.listOf (types.enum availableComponents);
      default = [
        # List of components required to complete the onboarding
        "default_config"
        "met"
        "esphome"
      ] ++ optionals (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) [
        # Use the platform as an indicator that we might be running on a RaspberryPi and include
        # relevant components
        "rpi_power"
      ];
      example = literalExpression ''
        [
          "analytics"
          "default_config"
          "esphome"
          "my"
          "shopping_list"
          "wled"
        ]
      '';
      description = ''
        List of <link xlink:href="https://www.home-assistant.io/integrations/">components</link> that have their dependencies included in the package.

        The component name can be found in the URL, for example <literal>https://www.home-assistant.io/integrations/ffmpeg/</literal> would map to <literal>ffmpeg</literal>.
      '';
    };

    extraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = _: [];
      defaultText = literalExpression ''
        python3Packages: with python3Packages; [];
      '';
      example = literalExpression ''
        python3Packages: with python3Packages; [
          # postgresql support
          psycopg2
        ];
      '';
      description = ''
        List of packages to add to propagatedBuildInputs.

        A popular example is <package>python3Packages.psycopg2</package>
        for PostgreSQL support in the recorder component.
      '';
    };

    config = mkOption {
      type = types.nullOr (types.submodule {
        freeformType = format.type;
        options = {
          # This is a partial selection of the most common options, so new users can quickly
          # pick up how to match home-assistants config structure to ours. It also lets us preset
          # config values intelligently.

          homeassistant = {
            # https://www.home-assistant.io/docs/configuration/basic/
            name = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "Home";
              description = ''
                Name of the location where Home Assistant is running.
              '';
            };

            latitude = mkOption {
              type = types.nullOr (types.either types.float types.str);
              default = null;
              example = 52.3;
              description = ''
                Latitude of your location required to calculate the time the sun rises and sets.
              '';
            };

            longitude = mkOption {
              type = types.nullOr (types.either types.float types.str);
              default = null;
              example = 4.9;
              description = ''
                Longitude of your location required to calculate the time the sun rises and sets.
              '';
            };

            unit_system = mkOption {
              type = types.nullOr (types.enum [ "metric" "imperial" ]);
              default = null;
              example = "metric";
              description = ''
                The unit system to use. This also sets temperature_unit, Celsius for Metric and Fahrenheit for Imperial.
              '';
            };

            temperature_unit = mkOption {
              type = types.nullOr (types.enum [ "C" "F" ]);
              default = null;
              example = "C";
              description = ''
                Override temperature unit set by unit_system. <literal>C</literal> for Celsius, <literal>F</literal> for Fahrenheit.
              '';
            };

            time_zone = mkOption {
              type = types.nullOr types.str;
              default = config.time.timeZone or null;
              defaultText = literalExpression ''
                config.time.timeZone or null
              '';
              example = "Europe/Amsterdam";
              description = ''
                Pick your time zone from the column TZ of Wikipedia’s <link xlink:href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">list of tz database time zones</link>.
              '';
            };
          };

          http = {
            # https://www.home-assistant.io/integrations/http/
            server_host = mkOption {
              type = types.either types.str (types.listOf types.str);
              default = [
                "0.0.0.0"
                "::"
              ];
              example = "::1";
              description = ''
                Only listen to incoming requests on specific IP/host. The default listed assumes support for IPv4 and IPv6.
              '';
            };

            server_port = mkOption {
              default = 8123;
              type = types.port;
              description = ''
                The port on which to listen.
              '';
            };
          };

          lovelace = {
            # https://www.home-assistant.io/lovelace/dashboards/
            mode = mkOption {
              type = types.enum [ "yaml" "storage" ];
              default = if cfg.lovelaceConfig != null
                then "yaml"
                else "storage";
              defaultText = literalExpression ''
                if cfg.lovelaceConfig != null
                  then "yaml"
                else "storage";
              '';
              example = "yaml";
              description = ''
                In what mode should the main Lovelace panel be, <literal>yaml</literal> or <literal>storage</literal> (UI managed).
              '';
            };
          };
        };
      });
      example = literalExpression ''
        {
          homeassistant = {
            name = "Home";
            latitude = "!secret latitude";
            longitude = "!secret longitude";
            elevation = "!secret elevation";
            unit_system = "metric";
            time_zone = "UTC";
          };
          frontend = {
            themes = "!include_dir_merge_named themes";
          };
          http = {};
          feedreader.urls = [ "https://nixos.org/blogs.xml" ];
        }
      '';
      description = ''
        Your <filename>configuration.yaml</filename> as a Nix attribute set.

        YAML functions like <link xlink:href="https://www.home-assistant.io/docs/configuration/secrets/">secrets</link>
        can be passed as a string and will be unquoted automatically.

        Unless this option is explicitly set to <literal>null</literal>
        we assume your <filename>configuration.yaml</filename> is
        managed through this module and thereby overwritten on startup.
      '';
    };

    configWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make <filename>configuration.yaml</filename> writable.

        This will allow you to edit it from Home Assistant's web interface.

        This only has an effect if <option>config</option> is set.
        However, bear in mind that it will be overwritten at every start of the service.
      '';
    };

    lovelaceConfig = mkOption {
      default = null;
      type = types.nullOr format.type;
      # from https://www.home-assistant.io/lovelace/dashboards/
      example = literalExpression ''
        {
          title = "My Awesome Home";
          views = [ {
            title = "Example";
            cards = [ {
              type = "markdown";
              title = "Lovelace";
              content = "Welcome to your **Lovelace UI**.";
            } ];
          } ];
        }
      '';
      description = ''
        Your <filename>ui-lovelace.yaml</filename> as a Nix attribute set.
        Setting this option will automatically set <literal>lovelace.mode</literal> to <literal>yaml</literal>.

        Beware that setting this option will delete your previous <filename>ui-lovelace.yaml</filename>
      '';
    };

    lovelaceConfigWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make <filename>ui-lovelace.yaml</filename> writable.

        This will allow you to edit it from Home Assistant's web interface.

        This only has an effect if <option>lovelaceConfig</option> is set.
        However, bear in mind that it will be overwritten at every start of the service.
      '';
    };

    package = mkOption {
      default = pkgs.home-assistant.overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });
      defaultText = literalExpression ''
        pkgs.home-assistant.overrideAttrs (oldAttrs: {
          doInstallCheck = false;
        })
      '';
      type = types.package;
      example = literalExpression ''
        pkgs.home-assistant.override {
          extraPackages = python3Packages: with python3Packages; [
            psycopg2
          ];
          extraComponents = [
            "default_config"
            "esphome"
            "met"
          ];
        }
      '';
      description = ''
        The Home Assistant package to use.
      '';
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.openFirewall -> !isNull cfg.config;
        message = "openFirewall can only be used with a declarative config";
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.config.http.server_port ];

    # symlink the configuration to /etc/home-assistant
    environment.etc = lib.mkMerge [
      (lib.mkIf (cfg.config != null && !cfg.configWritable) {
        "home-assistant/configuration.yaml".source = configFile;
      })

      (lib.mkIf (cfg.lovelaceConfig != null && !cfg.lovelaceConfigWritable) {
        "home-assistant/ui-lovelace.yaml".source = lovelaceConfigFile;
      })
    ];

    systemd.services.home-assistant = {
      description = "Home Assistant";
      after = [
        "network-online.target"

        # prevent races with database creation
        "mysql.service"
        "postgresql.service"
      ];
      reloadTriggers = lib.optional (cfg.config != null) configFile
      ++ lib.optional (cfg.lovelaceConfig != null) lovelaceConfigFile;

      preStart = let
        copyConfig = if cfg.configWritable then ''
          cp --no-preserve=mode ${configFile} "${cfg.configDir}/configuration.yaml"
        '' else ''
          rm -f "${cfg.configDir}/configuration.yaml"
          ln -s /etc/home-assistant/configuration.yaml "${cfg.configDir}/configuration.yaml"
        '';
        copyLovelaceConfig = if cfg.lovelaceConfigWritable then ''
          cp --no-preserve=mode ${lovelaceConfigFile} "${cfg.configDir}/ui-lovelace.yaml"
        '' else ''
          rm -f "${cfg.configDir}/ui-lovelace.yaml"
          ln -s /etc/home-assistant/ui-lovelace.yaml "${cfg.configDir}/ui-lovelace.yaml"
        '';
      in
        (optionalString (cfg.config != null) copyConfig) +
        (optionalString (cfg.lovelaceConfig != null) copyLovelaceConfig)
      ;
      serviceConfig = let
        # List of capabilities to equip home-assistant with, depending on configured components
        capabilities = [
          # Empty string first, so we will never accidentally have an empty capability bounding set
          # https://github.com/NixOS/nixpkgs/issues/120617#issuecomment-830685115
          ""
        ] ++ (unique (optionals (useComponent "bluetooth_tracker" || useComponent "bluetooth_le_tracker") [
          # Required for interaction with hci devices and bluetooth sockets
          # https://www.home-assistant.io/integrations/bluetooth_le_tracker/#rootless-setup-on-core-installs
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ] ++ lib.optionals (useComponent "emulated_hue") [
          # Alexa looks for the service on port 80
          # https://www.home-assistant.io/integrations/emulated_hue
          "CAP_NET_BIND_SERVICE"
        ] ++ lib.optionals (useComponent "nmap_tracker") [
          # https://www.home-assistant.io/integrations/nmap_tracker#linux-capabilities
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ]));
        componentsUsingBluetooth = [
          # Components that require the AF_BLUETOOTH address family
          "bluetooth_tracker"
          "bluetooth_le_tracker"
        ];
        componentsUsingPing = [
          # Components that require the capset syscall for the ping wrapper
          "ping"
          "wake_on_lan"
        ];
        componentsUsingSerialDevices = [
          # Components that require access to serial devices (/dev/tty*)
          # List generated from home-assistant documentation:
          #   git clone https://github.com/home-assistant/home-assistant.io/
          #   cd source/_integrations
          #   rg "/dev/tty" -l | cut -d'/' -f3 | cut -d'.' -f1 | sort
          # And then extended by references found in the source code, these
          # mostly the ones using config flows already.
          "acer_projector"
          "alarmdecoder"
          "arduino"
          "blackbird"
          "deconz"
          "dsmr"
          "edl21"
          "elkm1"
          "elv"
          "enocean"
          "firmata"
          "flexit"
          "gpsd"
          "insteon"
          "kwb"
          "lacrosse"
          "mhz19"
          "modbus"
          "modem_callerid"
          "mysensors"
          "nad"
          "numato"
          "rflink"
          "rfxtrx"
          "scsgate"
          "serial"
          "serial_pm"
          "sms"
          "upb"
          "usb"
          "velbus"
          "w800rf32"
          "xbee"
          "zha"
          "zwave"
          "zwave_js"
        ];
      in {
        ExecStart = "${package}/bin/hass --config '${cfg.configDir}'";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "hass";
        Group = "hass";
        Restart = "on-failure";
        RestartForceExitStatus = "100";
        SuccessExitStatus = "100";
        KillSignal = "SIGINT";

        # Hardening
        AmbientCapabilities = capabilities;
        CapabilityBoundingSet = capabilities;
        DeviceAllow = (optionals (any useComponent componentsUsingSerialDevices) [
          "char-ttyACM rw"
          "char-ttyAMA rw"
          "char-ttyUSB rw"
        ]);
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = false; # prevents gaining capabilities in the host namespace
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "all";
        ProtectSystem = "strict";
        RemoveIPC = true;
        ReadWritePaths = let
          # Allow rw access to explicitly configured paths
          cfgPath = [ "config" "homeassistant" "allowlist_external_dirs" ];
          value = attrByPath cfgPath [] cfg;
          allowPaths = if isList value then value else singleton value;
        in [ "${cfg.configDir}" ] ++ allowPaths;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ] ++ optionals (any useComponent componentsUsingBluetooth) [
          "AF_BLUETOOTH"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SupplementaryGroups = optionals (any useComponent componentsUsingSerialDevices) [
          "dialout"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ] ++ optionals (any useComponent componentsUsingPing) [
          "capset"
        ];
        UMask = "0077";
      };
      path = [
        "/run/wrappers" # needed for ping
      ];
    };

    systemd.targets.home-assistant = rec {
      description = "Home Assistant";
      wantedBy = [ "multi-user.target" ];
      wants = [ "home-assistant.service" ];
      after = wants;
    };

    users.users.hass = {
      home = cfg.configDir;
      createHome = true;
      group = "hass";
      uid = config.ids.uids.hass;
    };

    users.groups.hass.gid = config.ids.gids.hass;
  };
}
