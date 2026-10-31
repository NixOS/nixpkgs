{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.extra-container;
in
{
  options = {
    programs.extra-container.enable = lib.mkEnableOption ''
      extra-container, a tool for running declarative NixOS containers
      without host system rebuilds
    '';
    programs.extra-container.package = lib.mkPackageOption pkgs "extra-container" { };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    boot.extraSystemdUnitPaths = [ "/etc/systemd-mutable/system" ];
  };
}
