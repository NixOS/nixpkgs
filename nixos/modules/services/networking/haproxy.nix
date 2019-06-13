{ config, lib, pkgs, ... }:
let
  cfg = config.services.haproxy;
  haproxyCfg = pkgs.writeText "haproxy.conf" cfg.config;
in
with lib;
{
  options = {
    services.haproxy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable HAProxy, the reliable, high performance TCP/HTTP
          load balancer.
        '';
      };

      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Contents of the HAProxy configuration file,
          <filename>haproxy.conf</filename>.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [{
      assertion = cfg.config != null;
      message = "You must provide services.haproxy.config.";
    }];

    systemd.services.haproxy = {
      description = "HAProxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/haproxy.pid";
        ExecStartPre = "${pkgs.haproxy}/sbin/haproxy -c -q -f ${haproxyCfg}";
        ExecStart = "${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /run/haproxy.pid";
        ExecReload = "-${pkgs.bash}/bin/bash -c \"exec ${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /run/haproxy.pid -sf $MAINPID\"";
      };
    };

    environment.systemPackages = [ pkgs.haproxy ];

    users.users.haproxy = {
      group = "haproxy";
      uid = config.ids.uids.haproxy;
    };

    users.groups.haproxy.gid = config.ids.uids.haproxy;
  };
}
