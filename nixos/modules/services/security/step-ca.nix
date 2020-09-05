{ config, lib, pkgs, ... }:

let cfg = config.services.step-ca;

in {
  options = {
    services.step-ca = {
      enable = lib.mkEnableOption "Step CA PKI Server.";
      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/step-ca";
        description = "Directory to store Step CA Service data";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "SmallStep CA";
        description = "Name of your CA.";
      };
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Hostname/FQDN of your CA.";

      };
      address = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Address to listen at, defaults to all interfaces.";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 9075;
        description = "Port to listen on.";
      };
      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description =
          "Path to file containing password of your first provisioner.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.step-ca = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.coreutils pkgs.step-ca pkgs.step-cli ];
      environment = { STEPPATH = "${cfg.dataDir}"; };
      script = ''
        mkdir -p ${cfg.dataDir}
        if [ ! -f "${cfg.dataDir}/ca-is-init" ]; then
          step ca init --ssh --name ${cfg.name} --dns ${cfg.hostname} \
            --address ${cfg.address}:${
              toString cfg.port
            } --provisioner ${cfg.user}\
               --password-file ${cfg.passwordFile}
          touch ${cfg.dataDir}/ca-is-init
        fi
        step-ca $(step path)/config/ca.json --password-file ${cfg.passwordFile}
      '';
      serviceConfig = {
        Type = "simple";
        ExecReload = "/run/current-system/sw/bin/kill -HUP $MAINPID";
        PIDFile = "step-ca.pid";
        Restart = "on-failure";
        WorkingDirectory = cfg.dataDir;
      };
    };
  };
}
