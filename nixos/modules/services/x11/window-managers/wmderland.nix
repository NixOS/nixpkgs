{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.wmderland;
in

{
  options.services.xserver.windowManager.wmderland = {
    enable = mkEnableOption "wmderland";

    extraSessionCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands executed just before wmderland is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        rofi
        dunst
        light
        hsetroot
        feh
        rxvt-unicode
      ];
      defaultText = literalExpression ''
        with pkgs; [
          rofi
          dunst
          light
          hsetroot
          feh
          rxvt-unicode
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "wmderland";
      start = ''
        ${cfg.extraSessionCommands}

        ${pkgs.wmderland}/bin/wmderland &
        waitPID=$!
      '';
    };
    environment.systemPackages = [
      pkgs.wmderland
      pkgs.wmderlandc
    ]
    ++ cfg.extraPackages;

    # `dunst` from `extraPackages` above ships a D-Bus service file.  The D-Bus
    # daemons do not look at the system profile, so it has to be registered
    # explicitly, but only when it is actually installed.
    services.dbus.packages = lib.optional (elem pkgs.dunst cfg.extraPackages) pkgs.dunst;
  };
}
