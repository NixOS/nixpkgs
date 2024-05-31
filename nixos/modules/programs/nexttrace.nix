{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nexttrace;

in
{
  options = {
    programs.nexttrace = {
      enable = lib.mkEnableOption "Nexttrace to the global environment and configure a setcap wrapper for it";
      package = lib.mkPackageOption pkgs "nexttrace" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.nexttrace = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      source = "${cfg.package}/bin/nexttrace";
    };
  };
}
