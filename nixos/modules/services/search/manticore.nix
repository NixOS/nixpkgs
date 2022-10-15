{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.manticore;

in {

  options = {
    services.manticore = {

      enable = mkEnableOption (mdDoc "Manticore Search full-text search solution");

      configFile = mkOption {
        type = types.path;
        default = "${pkgs.manticoresearch}/etc/manticoresearch/manticore.conf";
        description = lib.mdDoc "Path to Manticore configuration file.";
      };

    };
  };

  config = mkIf cfg.enable {

    systemd = {
      services.manticore = {
        wantedBy = [ "multi-user.target" ];
        description = "Manticore Search full-text search solution";
        after = [ "network.target" ];
        serviceConfig = {
          # Took config from upstream service https://github.com/manticoresoftware/manticoresearch/blob/master/dist/deb/manticore.service.in
          ExecStart = "${pkgs.manticoresearch}/bin/searchd --config ${cfg.configFile}";
          ExecStop = "${pkgs.manticoresearch}/bin/searchd --config ${cfg.configFile} --stopwait";
          KillMode = "process";
          KillSignal = "SIGTERM";
          SendSIGKILL = "no";
          LimitNOFILE = 65536;
          LimitCORE = "infinity";
          LimitMEMLOCK = "infinity";
          Restart = "on-failure";
          ExecStartPre="${pkgs.coreutils}/bin/mkdir -p /var/run/manticore";
          PIDFile = "/var/run/manticore/searchd.pid";
          # Took hardening config from module navidrome
          DynamicUser = true;
          LogsDirectory = "manticore";
          RuntimeDirectory = "manticore";
          StateDirectory = "manticore";
          ReadWritePaths = "";
          CapabilityBoundingSet = "";
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" ];
          RestrictRealtime = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          UMask = "0066";
          ProtectHostname = true;
        };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
