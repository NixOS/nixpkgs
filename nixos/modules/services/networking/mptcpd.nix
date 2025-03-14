{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.mptcpd;

in

{

  options = {

    services.mptcpd = {

      enable = lib.mkEnableOption "the Multipath TCP path management daemon";

      package = lib.mkPackageOption pkgs "mptcpd" { };

    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

  meta.maintainers = with lib.maintainers; [ nim65s ];
}
