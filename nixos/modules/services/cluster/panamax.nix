{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.panamax;

  panamax_api = pkgs.panamax_api.override { dataDir = cfg.dataDir + "/api"; };
  panamax_ui = pkgs.panamax_ui.override { dataDir = cfg.dataDir + "/ui"; };

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
      default = "http://127.0.0.1:2379";
      description = ''
        Panamax fleetctl endpoint.
      '';
    };

    journalEndpoint = mkOption {
      type = types.str;
      default = "http://127.0.0.1:19531";
      description = ''
        Panamax journal endpoint.
      '';
    };

    secretKey = mkOption {
      type = types.str;
      default = "SomethingVeryLong.";
      description = ''
        Panamax secret key (do change this).
      '';
    };

  };

  ##### Implementation
  config = mkIf cfg.enable {
    systemd.services.panamax-api = {
      description = "Panamax API";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fleet.service" "etcd.service" "docker.service" ];

      path = [ panamax_api ];
      environment = {
        RAILS_ENV = "production";
        JOURNAL_ENDPOINT = cfg.journalEndpoint;
        FLEETCTL_ENDPOINT = cfg.fleetctlEndpoint;
        PANAMAX_DATABASE_PATH = "${cfg.dataDir}/api/db/mnt/db.sqlite3";
      };

      preStart = ''
        rm -rf ${cfg.dataDir}/state/tmp
        mkdir -p ${cfg.dataDir}/api/{db/mnt,state/log,state/tmp}
        ln -sf ${panamax_api}/share/panamax-api/_db/{schema.rb,seeds.rb,migrate} ${cfg.dataDir}/api/db/

        if [ ! -f ${cfg.dataDir}/.created ]; then
          bundle exec rake db:setup
          bundle exec rake db:seed
          bundle exec rake panamax:templates:load || true
          touch ${cfg.dataDir}/.created
        else
          bundle exec rake db:migrate
        fi
      '';

      serviceConfig = {
        ExecStart = "${panamax_api}/bin/bundle exec rails server --binding 127.0.0.1 --port ${toString cfg.APIPort}";
        User = "panamax";
        Group = "panamax";
      };
    };

    systemd.services.panamax-ui = {
      description = "Panamax UI";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "panamax_api.service" ];

      path = [ panamax_ui ];
      environment = {
        RAILS_ENV = "production";
        JOURNAL_ENDPOINT = cfg.journalEndpoint;
        PMX_API_PORT_3000_TCP_ADDR = "localhost";
        PMX_API_PORT_3000_TCP_PORT = toString cfg.APIPort;
        SECRET_KEY_BASE = cfg.secretKey;
      };

      preStart = ''
        mkdir -p ${cfg.dataDir}/ui/state/{log,tmp}
        chown -R panamax:panamax ${cfg.dataDir}
      '';

      serviceConfig = {
        ExecStart = "${panamax_ui}/bin/bundle exec rails server --binding 127.0.0.1 --port ${toString cfg.UIPort}";
        User = "panamax";
        Group = "panamax";
        PermissionsStartOnly = true;
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
    services.cadvisor.enable = mkDefault true;
    services.cadvisor.port = mkDefault 3002;
    virtualisation.docker.enable = mkDefault true;

    environment.systemPackages = [ panamax_api panamax_ui ];
    users.extraGroups.panamax.gid = config.ids.gids.panamax;
  };
}
