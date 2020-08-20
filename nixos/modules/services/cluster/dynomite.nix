{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.dynomite;
  local_redis = any (value: value == "127.0.0.1:${toString config.services.redis.port}:1") cfg.settings.dyn_o_mite.servers;
  configFile = pkgs.runCommand "dynomite.yaml" {} ''echo '${builtins.toJSON cfg.settings}' | ${pkgs.yq}/bin/yq -y . > $out'';
in {
  options = {
    services.dynomite = {
      enable = mkEnableOption "dynomite server";
      settings = mkOption {
        type = types.attrs;
        default = {
          dyn_o_mite = {
            listen = "127.0.0.1:8102";
            dyn_listen =  "127.0.0.1:8101";
            tokens =  "101134286";
            servers = [ "127.0.0.1:${toString config.services.redis.port}:1" ];
            data_store = 0;
            mbuf_size = 16384;
            max_msgs = 300000;
          };
        };
        description = ''
          Configuration for dynomite, see <link xlink:href="https://github.com/Netflix/dynomite"/>
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.redis.enable = lib.mkDefault local_redis;

    systemd.services.dynomite = {
      description = "Dynomite";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optional local_redis "redis.service";
      requires = lib.optional local_redis "redis.service";

      serviceConfig = {
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = 2;
        TimeoutStopSec = 5;
        StartLimitInterval = 0;
        PrivateTmp = true;
        PrivateDevices = true;
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID";
        NoNewPrivileges = true;
        ExecStartPre = "${pkgs.dynomite}/bin/dynomite --test-conf --conf-file=${configFile}";
        ExecStart = "${pkgs.dynomite}/bin/dynomite --conf-file=${configFile}";
        ProtectSystem = "full";
        ProtectHome = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        LimitNOFILE = 16384;
        TasksMax = 8192;
      };
    };
  };
}
