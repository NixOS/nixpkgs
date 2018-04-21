{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.home-assistant;

  configFile = pkgs.writeText "configuration.yaml" (builtins.toJSON cfg.config);

  availableComponents = pkgs.home-assistant.availableComponents;

  # Given component "parentConfig.platform", returns whether config.parentConfig
  # is a list containing a set with set.platform == "platform".
  #
  # For example, the component sensor.luftdaten is used as follows:
  # config.sensor = [ {
  #   platform = "luftdaten";
  #   ...
  # } ];
  useComponentPlatform = component:
    let
      path = splitString "." component;
      parentConfig = attrByPath (init path) null cfg.config;
      platform = last path;
    in isList parentConfig && any
      (item: item.platform or null == platform)
      parentConfig;

  # Returns whether component is used in config
  useComponent = component:
    hasAttrByPath (splitString "." component) cfg.config
    || useComponentPlatform component;

  # List of components used in config
  extraComponents = filter useComponent availableComponents;

  package = if cfg.autoExtraComponents
    then (cfg.package.override { inherit extraComponents; })
    else cfg.package;

in {
  meta.maintainers = with maintainers; [ dotlambda ];

  options.services.home-assistant = {
    enable = mkEnableOption "Home Assistant";

    configDir = mkOption {
      default = "/var/lib/hass";
      type = types.path;
      description = "The config directory, where your <filename>configuration.yaml</filename> is located.";
    };

    config = mkOption {
      default = null;
      type = with types; nullOr attrs;
      example = literalExample ''
        {
          homeassistant = {
            name = "Home";
            time_zone = "UTC";
          };
          frontend = { };
          http = { };
          feedreader.urls = [ "https://nixos.org/blogs.xml" ];
        }
      '';
      description = ''
        Your <filename>configuration.yaml</filename> as a Nix attribute set.
        Beware that setting this option will delete your previous <filename>configuration.yaml</filename>.
      '';
    };

    package = mkOption {
      default = pkgs.home-assistant;
      defaultText = "pkgs.home-assistant";
      type = types.package;
      example = literalExample ''
        pkgs.home-assistant.override {
          extraPackages = ps: with ps; [ colorlog ];
        }
      '';
      description = ''
        Home Assistant package to use.
        Override <literal>extraPackages</literal> in order to add additional dependencies.
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
  };

  config = mkIf cfg.enable {
    systemd.services.home-assistant = {
      description = "Home Assistant";
      after = [ "network.target" ];
      preStart = lib.optionalString (cfg.config != null) ''
        rm -f ${cfg.configDir}/configuration.yaml
        ln -s ${configFile} ${cfg.configDir}/configuration.yaml
      '';
      serviceConfig = {
        ExecStart = ''
          ${package}/bin/hass --config "${cfg.configDir}"
        '';
        User = "hass";
        Group = "hass";
        Restart = "on-failure";
        ProtectSystem = "strict";
        ReadWritePaths = "${cfg.configDir}";
        PrivateTmp = true;
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

    users.extraUsers.hass = {
      home = cfg.configDir;
      createHome = true;
      group = "hass";
      uid = config.ids.uids.hass;
    };

    users.extraGroups.hass.gid = config.ids.gids.hass;
  };
}
