{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dublin-traceroute;

in {
  meta.maintainers = pkgs.dublin-traceroute.meta.maintainers;

  options = {
    programs.dublin-traceroute = {
      enable = lib.mkEnableOption ''
      dublin-traceroute, add it to the global environment and configure a setcap wrapper for it.
      '';

      package = lib.mkPackageOption pkgs "dublin-traceroute" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.dublin-traceroute = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = lib.getExe cfg.package;
    };
  };
}
