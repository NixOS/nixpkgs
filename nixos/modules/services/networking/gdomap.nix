{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gdomap;
in
{
  #
  # interface
  #
  options = {
    services.gdomap = {
      enable = mkEnableOption "GNUstep Distributed Objects name server";
   };
  };

  #
  # implementation
  #
  config = mkIf config.services.gdomap.enable {
    # NOTE: gdomap runs as root
    # TODO: extra user for gdomap?
    systemd.services.gdomap = {
      description = "gdomap server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path  = [ pkgs.gnustep.base ];
      serviceConfig.ExecStart = "${pkgs.gnustep.base}/bin/gdomap -f";
    };
  };
}
