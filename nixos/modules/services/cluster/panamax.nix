{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.panamax;

  panamax_api = pkgs.panamax_api.override { dataDir = cfg.dataDir+"/api"; };
  panamax_ui = pkgs.panamax_ui.override { dataDir = cfg.dataDir+"/ui"; };

in {

  ##### Interface
  options.services.panamax = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable Panamax service.
      '';
    };

    UIPort = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Panamax UI listening port.
      '';
    };

    APIPort = mkOption {
      type = types.int;
      default = 3000;
      description = ''
        Panamax UI listening port.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/panamax";
      description = ''
        Data dir for Panamax.
      '';
    };

    fleetctlEndpoint = mkOption {
      type = types.str;
      default = "http://127.0.0.1:4001";
      description = ''
        Fleetctl endpoint.
      '';
    };

    journalEndpoint = mkOption {
      type = types.str;
      default = "http://127.0.0.1:19531";
      description = ''
        Journal endpoint.
      '';
    };

    secretKey = mkOption {
      type = types.str;
      default = "SomethingVeryLong.";
      description = ''
        Secret key (do change this).
      '';
    };

  };

  ##### Implementation
  config = mkIf cfg.enable {
    systemd.services.panamax_api = {
      description = "Panamax API";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fleet.service" "etcd.service" "docker.service" ];
      environment = {
        JOURNAL_ENDPOINT = cfg.journalEndpoint;
        FLEETCTL_ENDPOINT = cfg.fleetctlEndpoint;
      };
      preStart = "${panamax_api}/bin/panamax-api-init";
      serviceConfig = {
        ExecStart = "${panamax_api}/bin/panamax-api-run --port ${toString cfg.APIPort}";
        User = "panamax";
        Group = "panamax";
      };
    };

    systemd.services.panamax_ui = {
      description = "Panamax UI";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "panamax_api.service" ];
      environment = {
        JOURNAL_ENDPOINT = cfg.journalEndpoint;
        PMX_API_PORT_3000_TCP_PORT = toString cfg.APIPort;
        SECRET_KEY_BASE = cfg.secretKey;
      };
      serviceConfig = {
        ExecStart = "${panamax_ui}/bin/panamax-ui-run --port ${toString cfg.UIPort}";
        User = "panamax";
        Group = "panamax";
      };
    };

    users.extraUsers.panamax =
    { uid = config.ids.uids.panamax;
      description = "Panamax user";
      createHome = true;
      home = cfg.dataDir;
      extraGroups = [ "docker" ];
    };

    services.journald.enableHttpGateway = mkDefault true;
    services.fleet.enable = mkDefault true;
    virtualisation.docker.enable = mkDefault true;

    environment.systemPackages = [ panamax_api panamax_ui ];
    users.extraGroups.panamax.gid = config.ids.gids.panamax;
  };
}
