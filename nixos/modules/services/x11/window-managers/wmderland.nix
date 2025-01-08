{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.wmderland;
in

{
  options.services.xserver.windowManager.wmderland = {
    enable = lib.mkEnableOption "wmderland";

    extraSessionCommands = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Shell commands executed just before wmderland is started.
      '';
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        rofi
        dunst
        light
        hsetroot
        feh
        rxvt-unicode
      ];
      defaultText = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
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
    ] ++ cfg.extraPackages;
  };
}
