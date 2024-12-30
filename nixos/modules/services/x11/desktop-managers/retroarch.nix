{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.desktopManager.retroarch;

in
{
  options.services.xserver.desktopManager.retroarch = {
    enable = lib.mkEnableOption "RetroArch";

    package = lib.mkPackageOption pkgs "retroarch" {
      example = "retroarch-full";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--verbose"
        "--host"
      ];
      description = "Extra arguments to pass to RetroArch.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.session = [
      {
        name = "RetroArch";
        start = ''
          ${cfg.package}/bin/retroarch -f ${lib.escapeShellArgs cfg.extraArgs} &
          waitPID=$!
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ j0hax ];
}
