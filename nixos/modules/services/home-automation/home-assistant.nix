{ config, lib, pkgs, utils, ... }:

let
  inherit (lib)
    any
    attrByPath
    attrValues
    concatMap
    converge
    elem
    escapeShellArg
    escapeShellArgs
    filter
    filterAttrsRecursive
    hasAttrByPath
    isAttrs
    isDerivation
    isList
    literalExpression
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    optionals
    optionalString
    recursiveUpdate
    singleton
    splitString
    types
    unique
  ;

  inherit (utils)
    escapeSystemdExecArgs
  ;

  cfg = config.services.home-assistant;
  format = pkgs.formats.yaml {};

  # Render config attribute sets to YAML
  # Values that are null will be filtered from the output, so this is one way to have optional
  # options shown in settings.
  # We post-process the result to add support for YAML functions, like secrets or includes, see e.g.
  # https://www.home-assistant.io/docs/configuration/secrets/
  filteredConfig = converge (filterAttrsRecursive (_: v: ! elem v [ null ])) (recursiveUpdate lovelaceResourceConfig (cfg.config or {}));
  configFile = pkgs.runCommandLocal "configuration.yaml" { } ''
    cp ${format.generate "configuration.yaml" filteredConfig} $out
    sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
  '';
  lovelaceConfigFile = format.generate "ui-lovelace.yaml" cfg.lovelaceConfig;

  # Components advertised by the home-assistant package
  inherit (cfg.package) availableIntegrations;

  # Components that were added by overriding the package
  explicitIntegrations = cfg.package.integrations;
  useIntegrationFromPackage = component: elem component explicitIntegrations;

  # Given a component "platform", looks up whether it is used in the config
  # as `platform = "platform";`.
  #
  # For example, the component mqtt.sensor is used as follows:
  # config.sensor = [ {
  #   platform = "mqtt";
  #   ...
  # } ];
  usedPlatforms = config:
    # don't recurse into derivations possibly creating an infinite recursion
    if isDerivation config then
      [ ]
    else if isAttrs config then
      optionals (config ? platform) [ config.platform ]
      ++ concatMap usedPlatforms (attrValues config)
    else if isList config then
      concatMap usedPlatforms config
    else [ ];

  useIntegrationFromPlatform = integration: elem integration (usedPlatforms cfg.config);
  useIntegrationFromConfig = integration: hasAttrByPath (splitString "." integration) cfg.config;

  # Returns whether integration is used in config, explicitly passed into package or
  # configured in the module.
  useIntegration = integration:
    useIntegrationFromConfig integration
    || useIntegrationFromPlatform integration
    || useIntegrationFromPackage integration
    || elem integration (cfg.defaultIntegrations ++ cfg.integrations);

  # Final list of integrations passed into the package to include required dependencies
  integrations = filter useIntegration availableIntegrations;

  finalPackage = (cfg.package.override (oldArgs: {
    # Respect overrides that already exist in the passed package and
    # concat it with values passed via the module.
    integrations = oldArgs.integrations or [] ++ integrations;
    extraPackages = ps: (oldArgs.extraPackages or (_: []) ps)
      ++ (cfg.extraPythonPackages ps)
      ++ (concatMap (component: component.propagatedBuildInputs or []) cfg.integrationPackages);
  }));

  # Create a directory that holds all lovelace modules
  lovelaceResourcesDirectory = pkgs.buildEnv {
    name = "home-assistant-custom-lovelace-modules";
    paths = cfg.lovelaceResourcePackages;
  };

  # Create parts of the lovelace config that reference lovelave modules as resources
  lovelaceResourceConfig = {
    lovelace.resources = map (resource: {
      url = "/local/nixos-lovelace-modules/${resource.entrypoint or (resource.pname + ".js")}?${resource.version}";
      type = "module";
    }) cfg.lovelaceResourcePackages;
  };
in {
  imports = [
    # Migrations in NixOS 22.05
    (mkRemovedOptionModule [ "services" "home-assistant" "applyDefaultConfig" ] "The default config was migrated into services.home-assistant.config")
    (mkRemovedOptionModule [ "services" "home-assistant" "autoExtraComponents" ] "Components are now parsed from services.home-assistant.config unconditionally")
    (mkRenamedOptionModule [ "services" "home-assistant" "port" ] [ "services" "home-assistant" "config" "http" "server_port" ])

    # Migrations in NixOS 24.11
    (mkRenamedOptionModule [ "services" "home-assistant" "extraPackages" ] [ "services" "home-assistant" "extraPythonPackages" ])
    (mkRenamedOptionModule [ "services" "home-assistant" "extraComponents" ] [ "services" "home-assistant" "integrations" ])
    (mkRenamedOptionModule [ "services" "home-assistant" "customComponents" ] [ "services" "home-assistant" "integrationPackages" ])
    (mkRenamedOptionModule [ "services" "home-assistant" "customLovelaceModules" ] [ "services" "home-assistant" "lovelaceResourcePackages" ])
  ];

  meta = {
    buildDocsInSandbox = false;
    maintainers = lib.teams.home-assistant.members;
  };

  options.services.home-assistant = {
    # Running home-assistant on NixOS is considered an installation method that is unsupported by the upstream project.
    # https://github.com/home-assistant/architecture/blob/master/adr/0012-define-supported-installation-method.md#decision
    enable = mkEnableOption "Home Assistant. Check the [wiki](https://wiki.nixos.org/wiki/Home_Assistant) to get started!";

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--debug" ];
      description = ''
        Extra arguments to pass to the hass executable.
      '';
    };

    configDir = mkOption {
      default = "/var/lib/hass";
      type = types.path;
      description = "The config directory, where your {file}`configuration.yaml` is located.";
    };

    defaultIntegrations = mkOption {
      type = types.listOf (types.enum availableIntegrations);
      # https://github.com/home-assistant/core/blob/2024.8.3/homeassistant/bootstrap.py#L178
      default = [
        # core functionality
        "analytics"
        "application_credentials"
        "backup"
        "frontend"
        "hardware"
        "logger"
        "network"
        "system_health"

        # key features
        "automation"
        "person"
        "scene"
        "script"
        "tag"
        "zone"

        # built-in helpers
        "counter"
        "input_boolean"
        "input_button"
        "input_datetime"
        "input_number"
        "input_select"
        "input_text"
        "schedule"
        "timer"
      ];
      readOnly = true;
      description = ''
        List of integrations that are always set up, unless in recovery mode.
      '';
    };

    integrations = mkOption {
      type = types.listOf (types.enum availableIntegrations);
      default = [
        # List of components required to complete the onboarding
        # homeassistant/components/onboarding/__init__.py
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        "analytics"
      ] ++ optionals pkgs.stdenv.hostPlatform.isAarch [
        "rpi_power"
      ];
      example = [
        "analytics"
        "default_config"
        "esphome"
        "my"
        "shopping_list"
        "wled"
      ];
      description = ''
        List of [built-in integrations](https://www.home-assistant.io/integrations/) for which dependencies will be provided.

        Its names can be found in the documentation URL, for example `https://www.home-assistant.io/integrations/ffmpeg/`
        would map to `ffmpeg`.
      '';
    };

    extraPythonPackages = mkOption {
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
        List of additional libraries to provide in the Python environment.

        A popular example is `python3Packages.psycopg2` for PostgreSQL support in the recorder component.
      '';
    };

    integrationPackages = mkOption {
      type = types.listOf (
        types.addCheck types.package (pkg: pkg.isHomeAssistantComponent or false) // {
          name = "home-assistant-component";
          description = "package that is a Home Assistant component";
        }
      );
      default = [];
      example = literalExpression ''
        with pkgs.home-assistant-custom-components; [
          prometheus_sensor
        ];
      '';
      description = ''
        List of community-maintained integration packages to install.

        Available components can be found below `pkgs.home-assistant-custom-components`.
      '';
    };

    lovelaceResourcePackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression ''
        with pkgs.home-assistant-custom-lovelace-modules; [
          mini-graph-card
          mini-media-player
        ];
      '';
      description = ''
        List of lovelace module packages (usually for cards/widgets) to load as lovelace resources.

        Available resource packages can be found below `pkgs.home-assistant-custom-lovelace-modules`.

        ::: {.note}
        Automatic loading only works with lovelace in `yaml` mode. In `storage` mode resources need to be configured
        from the "Manage resources" section that appears in the burger menu when editing dashboards.

        The base url for resources is `/local/nixos-lovelace-modules/` followed by the `.js` entrypoint of the card.
        :::
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
                Override temperature unit set by unit_system. `C` for Celsius, `F` for Fahrenheit.
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
                Pick your time zone from the column TZ of Wikipedia’s [list of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
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
                In what mode should the main Lovelace panel be, `yaml` or `storage` (UI managed).
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
          feedreader.urls = [ "https://lobste.rs/t/nix.rss" ];
        }
      '';
      description = ''
        Your {file}`configuration.yaml` as a Nix attribute set.

        YAML functions like [secrets](https://www.home-assistant.io/docs/configuration/secrets/)
        can be passed as a string and will be unquoted automatically.

        Unless this option is explicitly set to `null`
        we assume your {file}`configuration.yaml` is
        managed through this module and thereby overwritten on startup.
      '';
    };

    configWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make {file}`configuration.yaml` writable.

        This will allow you to edit it from Home Assistant's web interface.

        This only has an effect if {option}`config` is set.
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
        Your {file}`ui-lovelace.yaml` as a Nix attribute set.
        Setting this option will automatically set `lovelace.mode` to `yaml`.

        Beware that setting this option will delete your previous {file}`ui-lovelace.yaml`
      '';
    };

    lovelaceConfigWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make {file}`ui-lovelace.yaml` writable.

        This will allow you to edit it from Home Assistant's web interface.

        This only has an effect if {option}`lovelaceConfig` is set.
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
          integrations = [
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
        assertion = cfg.openFirewall -> cfg.config != null;
        message = "openFirewall can only be used with a declarative config";
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.config.http.server_port ];

    # symlink the configuration to /etc/home-assistant
    environment.etc = mkMerge [
      (mkIf (cfg.config != null && !cfg.configWritable) {
        "home-assistant/configuration.yaml".source = configFile;
      })

      (mkIf (cfg.lovelaceConfig != null && !cfg.lovelaceConfigWritable) {
        "home-assistant/ui-lovelace.yaml".source = lovelaceConfigFile;
      })
    ];

    systemd.services.home-assistant = {
      description = "Home Assistant";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"

        # prevent races with database creation
        "mysql.service"
        "postgresql.service"
      ];
      reloadTriggers = optionals (cfg.config != null) [ configFile ]
      ++ optionals (cfg.lovelaceConfig != null) [ lovelaceConfigFile ];

      preStart = let
        copyConfig = if cfg.configWritable then ''
          cp --no-preserve=mode ${configFile} "${cfg.configDir}/configuration.yaml"
        '' else ''
          rm -f "${cfg.configDir}/configuration.yaml"
          ln -s /etc/home-assistant/configuration.yaml "${cfg.configDir}/configuration.yaml"
        '';
        copyLovelaceConfig = if cfg.lovelaceConfigWritable then ''
          rm -f "${cfg.configDir}/ui-lovelace.yaml"
          cp --no-preserve=mode ${lovelaceConfigFile} "${cfg.configDir}/ui-lovelace.yaml"
        '' else ''
          ln -fs /etc/home-assistant/ui-lovelace.yaml "${cfg.configDir}/ui-lovelace.yaml"
        '';
        copyLovelaceResources = if cfg.lovelaceResourcePackages != [] then ''
          mkdir -p "${cfg.configDir}/www"
          ln -fns ${lovelaceResourcesDirectory} "${cfg.configDir}/www/nixos-lovelace-modules"
        '' else ''
          rm -f "${cfg.configDir}/www/nixos-lovelace-modules"
        '';
        copyIntegrationPackages = ''
          mkdir -p "${cfg.configDir}/custom_components"

          # remove components symlinked in from below the /nix/store
          readarray -d "" components < <(find "${cfg.configDir}/custom_components" -maxdepth 1 -type l -print0)
          for component in "''${components[@]}"; do
            if [[ "$(readlink "$component")" =~ ^${escapeShellArg builtins.storeDir} ]]; then
              rm "$component"
            fi
          done

          # recreate symlinks for desired components
          declare -a components=(${escapeShellArgs cfg.integrationPackages})
          for component in "''${components[@]}"; do
            readarray -t manifests < <(find "$component" -name manifest.json)
            readarray -t paths < <(dirname "''${manifests[@]}")
            ln -fns "''${paths[@]}" "${cfg.configDir}/custom_components/"
          done
        '';
      in
        (optionalString (cfg.config != null) copyConfig) +
        (optionalString (cfg.lovelaceConfig != null) copyLovelaceConfig) +
        copyLovelaceResources +
        copyIntegrationPackages
      ;
      environment.PYTHONPATH = finalPackage.pythonPath;
      serviceConfig = let
        # List of capabilities to equip home-assistant with, depending on configured components
        capabilities = unique ([
          # Empty string first, so we will never accidentally have an empty capability bounding set
          # https://github.com/NixOS/nixpkgs/issues/120617#issuecomment-830685115
          ""
        ] ++ optionals (any useIntegration componentsUsingBluetooth) [
          # Required for interaction with hci devices and bluetooth sockets, identified by bluetooth-adapters dependency
          # https://www.home-assistant.io/integrations/bluetooth_le_tracker/#rootless-setup-on-core-installs
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ] ++ optionals (useIntegration "emulated_hue") [
          # Alexa looks for the service on port 80
          # https://www.home-assistant.io/integrations/emulated_hue
          "CAP_NET_BIND_SERVICE"
        ] ++ optionals (useIntegration "nmap_tracker") [
          # https://www.home-assistant.io/integrations/nmap_tracker#linux-capabilities
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ]);
        componentsUsingBluetooth = [
          # Components that require the AF_BLUETOOTH address family
          "august"
          "august_ble"
          "airthings_ble"
          "aranet"
          "bluemaestro"
          "bluetooth"
          "bluetooth_adapters"
          "bluetooth_le_tracker"
          "bluetooth_tracker"
          "bthome"
          "default_config"
          "eufylife_ble"
          "esphome"
          "fjaraskupan"
          "gardena_bluetooth"
          "govee_ble"
          "homekit_controller"
          "inkbird"
          "improv_ble"
          "keymitt_ble"
          "ld2410_ble"
          "leaone"
          "led_ble"
          "medcom_ble"
          "melnor"
          "moat"
          "mopeka"
          "motionblinds_ble"
          "oralb"
          "private_ble_device"
          "qingping"
          "rapt_ble"
          "ruuvi_gateway"
          "ruuvitag_ble"
          "sensirion_ble"
          "sensorpro"
          "sensorpush"
          "shelly"
          "snooz"
          "switchbot"
          "thermobeacon"
          "thermopro"
          "tilt_ble"
          "xiaomi_ble"
          "yalexs_ble"
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
          "aurora_abb_powerone"
          "blackbird"
          "bryant_evolution"
          "crownstone"
          "deconz"
          "dsmr"
          "edl21"
          "elkm1"
          "elv"
          "enocean"
          "homeassistant_hardware"
          "homeassistant_yellow"
          "firmata"
          "flexit"
          "gpsd"
          "insteon"
          "kwb"
          "lacrosse"
          "landisgyr_heat_meter"
          "modbus"
          "modem_callerid"
          "mysensors"
          "nad"
          "numato"
          "nut"
          "opentherm_gw"
          "otbr"
          "rainforst_raven"
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
          "zha"
          "zwave"
          "zwave_js"
        ];
      in {
        ExecStart = escapeSystemdExecArgs ([
          (lib.getExe finalPackage)
          "--config" cfg.configDir
        ] ++ cfg.extraArgs);
        ExecReload = (escapeSystemdExecArgs [
          (lib.getExe' pkgs.coreutils "kill")
          "-HUP"
        ]) + " $MAINPID";
        User = "hass";
        Group = "hass";
        WorkingDirectory = cfg.configDir;
        Restart = "on-failure";

        # Signal handling
        # homeassistant/helpers/signal.py
        RestartForceExitStatus = "100";
        SuccessExitStatus = "100";
        KillSignal = "SIGINT";

        # Hardening
        AmbientCapabilities = capabilities;
        CapabilityBoundingSet = capabilities;
        DeviceAllow = (optionals (any useIntegration componentsUsingSerialDevices) [
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
        ] ++ optionals (any useIntegration componentsUsingBluetooth) [
          "AF_BLUETOOTH"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SupplementaryGroups = optionals (any useIntegration componentsUsingSerialDevices) [
          "dialout"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ] ++ optionals (any useIntegration componentsUsingPing) [
          "capset"
          "setuid"
        ];
        UMask = "0077";
      };
      path = [
        pkgs.unixtools.ping # needed for ping
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
