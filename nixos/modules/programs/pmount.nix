{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';

  cfg = config.programs.pmount;

  mkSetuidWrapper = package: command: {
    setuid = true;
    owner = "root";
    group = "root";
    source = getExe' package command;
  };
in
{
  options.programs.pmount = {
    enable = mkEnableOption ''
      pmount, a tool that allows normal users to mount removable devices
      without requiring root privileges
    '';

    package = mkPackageOption pkgs "pmount" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers = {
      pmount = mkSetuidWrapper cfg.package "pmount";
      pumount = mkSetuidWrapper cfg.package "pumount";
    };

    systemd.tmpfiles.rules = [
      "d /media - root root - -"
    ];
  };
}
