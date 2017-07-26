{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lldpd;

in

{
  options.services.lldpd = {
    enable = mkEnableOption "Link Layer Discovery Protocol Daemon";

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-c" "-k" "-I eth0" ];
      description = "List of command line parameters for lldpd";
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers._lldpd = {
      description = "lldpd user";
      group = "_lldpd";
      home = "/var/run/lldpd";
    };
    users.extraGroups._lldpd = {};

    environment.systemPackages = [ pkgs.lldpd ];

    systemd.services.lldpd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lldpd}/bin/lldpd -d ${concatStringsSep " " cfg.extraArgs}";
        PrivateTmp = true;
        PrivateDevices = true;
      };
    };
  };
}
