{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.desktopManager.retroarch;

in {
  options.services.xserver.desktopManager.retroarch = {
    enable = mkEnableOption (lib.mdDoc "RetroArch");

    package = mkOption {
      type = types.package;
      default = pkgs.retroarch;
      defaultText = literalExpression "pkgs.retroarch";
      example = literalExpression "pkgs.retroarch-full";
      description = lib.mdDoc "RetroArch package to use.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" "--host" ];
      description = lib.mdDoc "Extra arguments to pass to RetroArch.";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "RetroArch";
      start = ''
        ${cfg.package}/bin/retroarch -f ${escapeShellArgs cfg.extraArgs} &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with maintainers; [ j0hax ];
}
