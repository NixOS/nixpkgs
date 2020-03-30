{ config, lib, pkgs, ... }:

let
  cfg = config.services.haproxy;

  haproxyCfg = pkgs.writeText "haproxy.conf" ''
    global
      # needed for hot-reload to work without dropping packets in multi-worker mode
      stats socket /run/haproxy/haproxy.sock mode 600 expose-fd listeners level user

    ${cfg.config}
  '';

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

      user = mkOption {
        type = types.str;
        default = "haproxy";
        description = "User account under which haproxy runs.";
      };

      group = mkOption {
        type = types.str;
        default = "haproxy";
        description = "Group account under which haproxy runs.";
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
        User = cfg.user;
        Group = cfg.group;
        Type = "notify";
        # when running the config test, don't be quiet so we can see what goes wrong
        ExecStartPre = "${pkgs.haproxy}/sbin/haproxy -c -f ${haproxyCfg}";
        ExecStart = "${pkgs.haproxy}/sbin/haproxy -Ws -f ${haproxyCfg}";
        Restart = "on-failure";
        RuntimeDirectory = "haproxy";
        # needed in case we bind to port < 1024
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };

    users.users = optionalAttrs (cfg.user == "haproxy") {
      haproxy = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "haproxy") {
      haproxy = {};
    };
  };
}
