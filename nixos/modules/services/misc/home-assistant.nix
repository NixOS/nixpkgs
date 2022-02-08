{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.home-assistant;

  # cfg.config != null can be assumed here
  configJSON = pkgs.writeText "configuration.json"
    (builtins.toJSON (if cfg.applyDefaultConfig then
    (recursiveUpdate defaultConfig cfg.config) else cfg.config));
  configFile = pkgs.runCommand "configuration.yaml" { preferLocalBuild = true; } ''
    ${pkgs.remarshal}/bin/json2yaml -i ${configJSON} -o $out
    # Hack to support custom yaml objects,
    # i.e. secrets: https://www.home-assistant.io/docs/configuration/secrets/
    sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
  '';

  lovelaceConfigJSON = pkgs.writeText "ui-lovelace.json"
    (builtins.toJSON cfg.lovelaceConfig);
  lovelaceConfigFile = pkgs.runCommand "ui-lovelace.yaml" { preferLocalBuild = true; } ''
    ${pkgs.remarshal}/bin/json2yaml -i ${lovelaceConfigJSON} -o $out
  '';

  availableComponents = cfg.package.availableComponents;

  explicitComponents = cfg.package.extraComponents;

  usedPlatforms = config:
    if isAttrs config then
      optional (config ? platform) config.platform
      ++ concatMap usedPlatforms (attrValues config)
    else if isList config then
      concatMap usedPlatforms config
    else [ ];

  # Given a component "platform", looks up whether it is used in the config
  # as `platform = "platform";`.
  #
  # For example, the component mqtt.sensor is used as follows:
  # config.sensor = [ {
  #   platform = "mqtt";
  #   ...
  # } ];
  useComponentPlatform = component: elem component (usedPlatforms cfg.config);

  useExplicitComponent = component: elem component explicitComponents;

  # Returns whether component is used in config or explicitly passed into package
  useComponent = component:
    hasAttrByPath (splitString "." component) cfg.config
    || useComponentPlatform component
    || useExplicitComponent component;

  # List of components used in config
  extraComponents = filter useComponent availableComponents;

  package = if (cfg.autoExtraComponents && cfg.config != null)
    then (cfg.package.override { inherit extraComponents; })
    else cfg.package;

  # If you are changing this, please update the description in applyDefaultConfig
  defaultConfig = {
    homeassistant.time_zone = config.time.timeZone;
    http.server_port = cfg.port;
  } // optionalAttrs (cfg.lovelaceConfig != null) {
    lovelace.mode = "yaml";
  };

in {
  meta.maintainers = teams.home-assistant.members;

  options.services.home-assistant = {
    # Running home-assistant on NixOS is considered an installation method that is unsupported by the upstream project.
    # https://github.com/home-assistant/architecture/blob/master/adr/0012-define-supported-installation-method.md#decision
    enable = mkEnableOption "Home Assistant. Please note that this installation method is unsupported upstream";

    configDir = mkOption {
      default = "/var/lib/hass";
      type = types.path;
      description = "The config directory, where your <filename>configuration.yaml</filename> is located.";
    };

    port = mkOption {
      default = 8123;
      type = types.port;
      description = "The port on which to listen.";
    };

    applyDefaultConfig = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Setting this option enables a few configuration options for HA based on NixOS configuration (such as time zone) to avoid having to manually specify configuration we already have.
        </para>
        <para>
        Currently one side effect of enabling this is that the <literal>http</literal> component will be enabled.
        </para>
        <para>
        This only takes effect if <literal>config != null</literal> in order to ensure that a manually managed <filename>configuration.yaml</filename> is not overwritten.
      '';
    };

    config = mkOption {
      default = null;
      # Migrate to new option types later: https://github.com/NixOS/nixpkgs/pull/75584
      type =  with lib.types; let
          valueType = nullOr (oneOf [
            bool
            int
            float
            str
            (lazyAttrsOf valueType)
            (listOf valueType)
          ]) // {
            description = "Yaml value";
            emptyValue.value = {};
          };
        in valueType;
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
          http = { };
          feedreader.urls = [ "https://nixos.org/blogs.xml" ];
        }
      '';
      description = ''
        Your <filename>configuration.yaml</filename> as a Nix attribute set.
        Beware that setting this option will delete your previous <filename>configuration.yaml</filename>.
        <link xlink:href="https://www.home-assistant.io/docs/configuration/secrets/">Secrets</link>
        are encoded as strings as shown in the example.
      '';
    };

    configWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make <filename>configuration.yaml</filename> writable.
        This only has an effect if <option>config</option> is set.
        This will allow you to edit it from Home Assistant's web interface.
        However, bear in mind that it will be overwritten at every start of the service.
      '';
    };

    lovelaceConfig = mkOption {
      default = null;
      type = with types; nullOr attrs;
      # from https://www.home-assistant.io/lovelace/yaml-mode/
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
        Setting this option will automatically add
        <literal>lovelace.mode = "yaml";</literal> to your <option>config</option>.
        Beware that setting this option will delete your previous <filename>ui-lovelace.yaml</filename>
      '';
    };

    lovelaceConfigWritable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to make <filename>ui-lovelace.yaml</filename> writable.
        This only has an effect if <option>lovelaceConfig</option> is set.
        This will allow you to edit it from Home Assistant's web interface.
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
          extraPackages = ps: with ps; [ colorlog ];
        }
      '';
      description = ''
        Home Assistant package to use. By default the tests are disabled, as they take a considerable amout of time to complete.
        Override <literal>extraPackages</literal> or <literal>extraComponents</literal> in order to add additional dependencies.
        If you specify <option>config</option> and do not set <option>autoExtraComponents</option>
        to <literal>false</literal>, overriding <literal>extraComponents</literal> will have no effect.
        Avoid <literal>home-assistant.overridePythonAttrs</literal> if you use <literal>autoExtraComponents</literal>.
      '';
    };

    autoExtraComponents = mkOption {
      default = true;
      type = types.bool;
      description = ''
        If set to <literal>true</literal>, the components used in <literal>config</literal>
        are set as the specified package's <literal>extraComponents</literal>.
        This in turn adds all packaged dependencies to the derivation.
        You might still see import errors in your log.
        In this case, you will need to package the necessary dependencies yourself
        or ask for someone else to package them.
        If a dependency is packaged but not automatically added to this list,
        you might need to specify it in <literal>extraPackages</literal>.
      '';
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.home-assistant = {
      description = "Home Assistant";
      after = [ "network.target" ];
      preStart = optionalString (cfg.config != null) (if cfg.configWritable then ''
        cp --no-preserve=mode ${configFile} "${cfg.configDir}/configuration.yaml"
      '' else ''
        rm -f "${cfg.configDir}/configuration.yaml"
        ln -s ${configFile} "${cfg.configDir}/configuration.yaml"
      '') + optionalString (cfg.lovelaceConfig != null) (if cfg.lovelaceConfigWritable then ''
        cp --no-preserve=mode ${lovelaceConfigFile} "${cfg.configDir}/ui-lovelace.yaml"
      '' else ''
        rm -f "${cfg.configDir}/ui-lovelace.yaml"
        ln -s ${lovelaceConfigFile} "${cfg.configDir}/ui-lovelace.yaml"
      '');
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
