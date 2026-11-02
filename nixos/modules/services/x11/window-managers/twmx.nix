{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.twmx;
in
{
  options.services.xserver.windowManager.twmx = {
    enable = lib.mkEnableOption "twmx";

    extraSessionCommands = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Shell commands executed just before twmx is started.
      '';
    };

    package = lib.mkPackageOption pkgs "twmx" {
      example = ''
        pkgs.twmx.override {
          conf = ./config.h;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "twmx";
      start = ''
        ${cfg.extraSessionCommands}

        export _JAVA_AWT_WM_NONREPARENTING=1
        ${lib.getExe cfg.package} &
        waitPID=$!
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
