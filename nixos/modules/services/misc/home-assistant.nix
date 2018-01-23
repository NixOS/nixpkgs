{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.home-assistant;

  configFile = pkgs.writeText "configuration.yaml" (builtins.toJSON cfg.config);
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
        Most Home Assistant components require additional dependencies,
        which are best specified by overriding <literal>pkgs.home-assistant</literal>.
        You can find the dependencies by searching for failed imports in your log or by looking at this list:
        <link xlink:href="https://github.com/home-assistant/home-assistant/blob/master/requirements_all.txt"/>
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.home-assistant = {
      description = "Home Assistant";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = lib.optionalString (cfg.config != null) ''
        rm -f ${cfg.configDir}/configuration.yaml
        ln -s ${configFile} ${cfg.configDir}/configuration.yaml
      '';
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/hass --config "${cfg.configDir}"
        '';
        User = "hass";
        Group = "hass";
        Restart = "on-failure";
        ProtectSystem = "strict";
        ReadWritePaths = "${cfg.configDir}";
        PrivateTmp = true;
      };
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
