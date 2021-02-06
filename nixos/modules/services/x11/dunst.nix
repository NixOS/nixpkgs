{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dunst;
  reservedSections = [
    "global" "experimental" "frame" "shortcuts"
    "urgency_low" "urgency_normal" "urgency_critical"
  ];
in {

options.services.dunst = {

  enable = mkEnableOption "the dunst notifications daemon";

  iconDirs = mkOption {
    type = with types; listOf path;
    default = [];
    example = literalExample ''
      [ "''${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita/48x48" ]
    '';
    description = ''
      Paths to icon folders.
    '';
  };

  extraArgs = mkOption {
    type = with types; listOf str;
    default = [];
    description = ''
      Extra command line options for dunst
    '';
  };

  globalConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = {};
    description = ''
      The global configuration section for dunst.
    '';
  };

  shortcutConfig = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = {};
    description = ''
      The shortcut configuration for dunst.
    '';
  };

  urgencyConfig = {
    low = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = {};
      description = ''
        The low urgency section of the dunst configuration.
      '';
    };
    normal = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = {};
      description = ''
        The normal urgency section of the dunst configuration.
      '';
    };
    critical = mkOption {
      type = with types; attrsOf (oneOf [bool str int]);
      default = {};
      description = ''
        The critical urgency section of the dunst configuration.
      '';
    };
  };

  rules = mkOption {
    type = with types; attrsOf (oneOf [bool str int]);
    default = {};
    description = ''
       These rules allow the conditional modification of notifications.

       Note that rule names may not be one of the following
       keywords already used internally:
         ${concatStringsSep ", " reservedSections}
       There are 2 parts in configuring a rule: Defining when a rule
       matches and should apply (called filtering in the man page)
       and then the actions that should be taken when the rule is
       matched (called modifying in the man page).
    '';
    example = literalExample ''
      signed_off = {
        appname = "Pidgin";
        summary = "*signed off*";
        urgency = "low";
        script = "pidgin-signed-off.sh";
      };
    '';
  };

};

config =
  let
    dunstConfig = lib.generators.toINI {} allOptions;
    allOptions = {
      global = cfg.globalConfig;
      shortcut = cfg.shortcutConfig;
      urgency_normal = cfg.urgencyConfig.normal;
      urgency_low = cfg.urgencyConfig.low;
      urgency_critical = cfg.urgencyConfig.critical;
    } // cfg.rules;

    iconPath = concatStringsSep ":" cfg.iconDirs;

    dunst-args = [
      "-config" (pkgs.writeText "dunstrc" dunstConfig)
      "-icon_path" iconPath
    ] ++ cfg.extraArgs;

  in mkIf cfg.enable {

    assertions = flip mapAttrsToList cfg.rules (name: conf: {
      assertion = ! elem name reservedSections;
      message = ''
        dunst config: ${name} is a reserved keyword. Please choose
        a different name for the rule.
      '';
    });

    systemd.user.services.dunst.serviceConfig.ExecStart = [ "" "${pkgs.dunst}/bin/dunst ${escapeShellArgs dunst-args}" ];
    # [ "" ... ] is needed to overwrite the ExecStart directive from the upstream service file

    systemd.packages = [ pkgs.dunst ];
    services.dbus.packages = [ pkgs.dunst ];
  };

}
