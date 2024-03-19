{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dublin-traceroute;

in {
  meta.maintainers = pkgs.dublin-traceroute.meta.maintainers;

  options = {
    programs.dublin-traceroute = {
      enable = mkEnableOption (mdDoc ''
      dublin-traceroute, add it to the global environment and configure a setcap wrapper for it.
      '');

      package = mkPackageOption pkgs "dublin-traceroute" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.dublin-traceroute = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = getExe cfg.package;
    };
  };
}
