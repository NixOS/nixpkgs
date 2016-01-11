{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cadvisor;

in {
  options = {
    services.cadvisor = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable cadvisor service.";
      };

      listenAddress = mkOption {
        default = "127.0.0.1";
        type = types.str;
        description = "Cadvisor listening host";
      };

      port = mkOption {
        default = 8080;
        type = types.int;
        description = "Cadvisor listening port";
      };

      storageDriver = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "influxdb";
        description = "Cadvisor storage driver.";
      };

      storageDriverHost = mkOption {
        default = "localhost:8086";
        type = types.str;
        description = "Cadvisor storage driver host.";
      };

      storageDriverDb = mkOption {
        default = "root";
        type = types.str;
        description = "Cadvisord storage driver database name.";
      };

      storageDriverUser = mkOption {
        default = "root";
        type = types.str;
        description = "Cadvisor storage driver username.";
      };

      storageDriverPassword = mkOption {
        default = "root";
        type = types.str;
        description = "Cadvisor storage driver password.";
      };

      storageDriverSecure = mkOption {
        default = false;
        type = types.bool;
        description = "Cadvisor storage driver, enable secure communication.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cadvisor = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "docker.service" "influxdb.service" ];

      postStart = mkBefore ''
        until ${pkgs.curl}/bin/curl -s -o /dev/null 'http://${cfg.listenAddress}:${toString cfg.port}/containers/'; do
          sleep 1;
        done
      '';

      serviceConfig = {
        ExecStart = ''${pkgs.cadvisor}/bin/cadvisor \
          -logtostderr=true \
          -listen_ip=${cfg.listenAddress} \
          -port=${toString cfg.port} \
          ${optionalString (cfg.storageDriver != null) ''
            -storage_driver ${cfg.storageDriver} \
            -storage_driver_user ${cfg.storageDriverHost} \
            -storage_driver_db ${cfg.storageDriverDb} \
            -storage_driver_user ${cfg.storageDriverUser} \
            -storage_driver_password ${cfg.storageDriverPassword} \
            ${optionalString cfg.storageDriverSecure "-storage_driver_secure"}
          ''}
        '';
      };
    };

    virtualisation.docker.enable = mkDefault true;
  };
}
