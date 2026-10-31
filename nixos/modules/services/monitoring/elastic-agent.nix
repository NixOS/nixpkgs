{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.elastic-agent;
  stateDir = "/var/lib/elastic-agent";
  elasticConfig = pkgs.writeText "elastic-agent.yml" cfg.yml;
in
{
  options = {
    services.elastic-agent = {
      enable = lib.mkEnableOption "Elastic Agent";
      package = lib.mkPackageOption pkgs "elastic-agent" { };
      ca = lib.mkOption {
        type = lib.types.path;
        description = "Path to root certificate for server verification used by Elastic Agent and Fleet Server";
      };
      yml = lib.mkOption {
        type = lib.types.lines;
        description = "elastic-agent.yml";
        default = "";
      };
      enrollInFleet = {
        description = "Configuration for enrolling Elastic Agent into Fleet.";
        enable = lib.mkEnableOption "Enroll Agent in Fleet";
        enrollmentToken = lib.mkOption {
          type = lib.types.str;
          description = "Path to file containing enrollment token to use to enroll Agent into Fleet";
        };
        url = lib.mkOption {
          type = lib.types.str;
          description = "URL to enroll Agent into Fleet";
        };
      };
      fleetServer = {
        description = "Config for running Fleet Server";
        enable = lib.mkEnableOption "Fleet Server";
        url = lib.mkOption {
          type = lib.types.str;
          description = "Fleet Server URL";
        };
        es = lib.mkOption {
          type = lib.types.str;
          description = "URL or IP Address for Elasticsearch";
        };
        serviceToken = lib.mkOption {
          type = lib.types.str;
          description = "Path to file containing service token for Fleet Server to use for communication with Elasticsearch";
        };
        policy = lib.mkOption {
          type = lib.types.str;
          description = "Start and run a Fleet Server on this specific policy";
        };
        esCa = lib.mkOption {
          type = lib.types.path;
          description = "Path to certificate authority for Fleet Server to use to communicate with Elasticsearch";
        };
        cert = lib.mkOption {
          type = lib.types.path;
          description = "Path to certificate for Fleet Server to use for exposed HTTPS endpoint";
        };
        certKey = lib.mkOption {
          type = lib.types.str;
          description = "Path to private key for the certificate used by Fleet Server for exposed HTTPS endpoint";
        };
        port = lib.mkOption {
          type = lib.types.port;
          description = "Fleet Server HTTP binding port";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.xor cfg.fleetServer.enable cfg.enrollInFleet.enable;
        message = "elastic-agent: either services.elastic-agent.enrollInFleet or services.elastic-agent.fleetServer must be enabled";
      }
    ];
    systemd.tmpfiles.rules = [
      "d /var/lib/elastic-agent 0750 root root -"
      "C ${stateDir}/elastic-agent.yml 0640 root root - ${elasticConfig}"
    ];
    systemd.services.elastic-agent = {
      description = "Elastic Agent";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];
      wants = [
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];
      preStart = ''
        if [ -f ${stateDir}/fleet.enc ]; then
          echo "elastic-agent:already enrolled (fleet.enc exists), skipping enrollment."
          exit 0
        fi

        ${lib.optionalString cfg.fleetServer.enable ''
          serviceToken="$(tr -d '\n' < ${cfg.fleetServer.serviceToken})"
          ${lib.getExe cfg.package} enroll --force \
            --url=${cfg.fleetServer.url} \
            --fleet-server-es=${cfg.fleetServer.es} \
            --fleet-server-es-ca=${cfg.fleetServer.esCa} \
            --fleet-server-service-token=$serviceToken \
            --fleet-server-policy=${cfg.fleetServer.policy} \
            --fleet-server-port=${toString cfg.fleetServer.port} \
            --fleet-server-cert=${cfg.fleetServer.cert} \
            --fleet-server-cert-key=${cfg.fleetServer.certKey} \
            --certificate-authorities=${cfg.ca} \
            --path.home ${stateDir} \
            --path.config ${stateDir} \
            --path.logs ${stateDir}/logs \
            --path.socket ${stateDir}/elastic-agent.sock
        ''}

        ${lib.optionalString cfg.enrollInFleet.enable ''
          enrollmentToken="$(tr -d '\n' < ${cfg.enrollInFleet.enrollmentToken})"
          ${lib.getExe cfg.package} enroll --delay-enroll \
            --enrollment-token=$enrollmentToken \
            --url=${cfg.enrollInFleet.url} \
            --certificate-authorities=${cfg.ca} \
            --path.config ${stateDir} \
            --path.downloads ${stateDir} \
            --path.home ${stateDir} \
            --path.logs ${stateDir}/logs
        ''}
      '';
      path = [ pkgs.coreutils ];
      serviceConfig = {
        User = "root";
        Group = "root";
        StateDirectory = "elastic-agent";
        WorkingDirectory = stateDir;
        ExecStart = ''
          ${lib.getExe cfg.package} run \
            --path.config ${stateDir} \
            --path.downloads ${stateDir} \
            --path.home ${stateDir} \
            --path.logs ${stateDir}/logs \
            --path.socket ${stateDir}/elastic-agent.sock
        '';
      };
    };
  };
  meta = {
    maintainers = [ lib.maintainers.rwyattwalker ];
  };
}
