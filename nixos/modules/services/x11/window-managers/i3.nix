{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.i3;
in

{
  options.services.xserver.windowManager.i3 = {
    enable = mkEnableOption (lib.mdDoc "i3 window manager");

    configFile = mkOption {
      default     = null;
      type        = with types; nullOr path;
      description = lib.mdDoc ''
        Path to the i3 configuration file.
        If left at the default value, $HOME/.i3/config will be used.
      '';
    };

    extraSessionCommands = mkOption {
      default     = "";
      type        = types.lines;
      description = lib.mdDoc ''
        Shell commands executed just before i3 is started.
      '';
    };

    package = mkOption {
      type        = types.package;
      default     = pkgs.i3;
      defaultText = literalExpression "pkgs.i3";
      description = lib.mdDoc ''
        i3 package to use.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [ dmenu i3status i3lock ];
      defaultText = literalExpression ''
        with pkgs; [
          dmenu
          i3status
          i3lock
        ]
      '';
      description = lib.mdDoc ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name  = "i3";
      start = ''
        ${cfg.extraSessionCommands}

        ${cfg.package}/bin/i3 ${optionalString (cfg.configFile != null)
          "-c /etc/i3/config"
        } &
        waitPID=$!
      '';
    }];
    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;
    environment.etc."i3/config" = mkIf (cfg.configFile != null) {
      source = cfg.configFile;
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "windowManager" "i3-gaps" "enable" ]
      "i3-gaps was merged into i3. Use services.xserver.windowManager.i3.enable instead.")
  ];
}
