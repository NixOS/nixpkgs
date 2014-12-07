{ pkgs, lib, config, options, ... }:

with lib;

let
  cfg = config.services.openntpd;

  package = pkgs.openntpd.override {
    privsepUser = "ntp";
    privsepPath = "/var/empty";
  };

  cfgFile = pkgs.writeText "openntpd.conf" ''
    ${concatStringsSep "\n" (map (s: "server ${s}") cfg.servers)}
  '';
in
{
  ###### interface

  options.services.openntpd = {
    enable = mkEnableOption "OpenNTP time synchronization server";

    servers = mkOption {
      default = config.services.ntp.servers;
      type = types.listOf types.str;
      inherit (options.services.ntp.servers) description;
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.ntp.enable = mkForce false;

    users.extraUsers = singleton {
      name = "ntp";
      uid = config.ids.uids.ntp;
      description = "OpenNTP daemon user";
      home = "/var/empty";
    };

    systemd.services.openntpd = {
      description = "OpenNTP Server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${package}/sbin/ntpd -d -f ${cfgFile}";
    };
  };
}
