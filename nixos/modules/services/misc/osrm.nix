{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.osrm;
in

{
  options.services.osrm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the OSRM service.";
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "IP address on which the web server will listen.";
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      description = "Port on which the web server will run.";
    };

    threads = mkOption {
      type = types.int;
      default = 4;
      description = "Number of threads to use.";
    };

    algorithm = mkOption {
      type = types.enum [
        "CH"
        "CoreCH"
        "MLD"
      ];
      default = "MLD";
      description = "Algorithm to use for the data. Must be one of CH, CoreCH, MLD";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "--max-table-size 1000"
        "--max-matching-size 1000"
      ];
      description = "Extra command line arguments passed to osrm-routed";
    };

    dataFile = mkOption {
      type = types.path;
      example = "/var/lib/osrm/berlin-latest.osrm";
      description = "Data file location";
    };

  };

  config = mkIf cfg.enable {

    users.users.osrm = {
      group = config.users.users.osrm.name;
      description = "OSRM user";
      createHome = false;
      isSystemUser = true;
    };

    users.groups.osrm = { };

    systemd.services.osrm = {
      description = "OSRM service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = config.users.users.osrm.name;
        ExecStart = ''
          ${pkgs.osrm-backend}/bin/osrm-routed \
            --ip ${cfg.address} \
            --port ${toString cfg.port} \
            --threads ${toString cfg.threads} \
            --algorithm ${cfg.algorithm} \
            ${toString cfg.extraFlags} \
            ${cfg.dataFile}
        '';
      };
    };
  };
}
