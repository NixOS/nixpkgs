{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.iperf3;

  api = {
    enable = lib.mkEnableOption "iperf3 network throughput testing server";
    package = lib.mkPackageOption pkgs "iperf3" { };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 5201;
      description = "Server port to listen on for iperf3 client requests.";
    };
    affinity = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = "CPU affinity for the process.";
    };
    bind = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Bind to the specific interface associated with the given address.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for iperf3.";
    };
    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Give more detailed output.";
    };
    forceFlush = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Force flushing output at every interval.";
    };
    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Emit debugging output.";
    };
    rsaPrivateKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the RSA private key (not password-protected) used to decrypt authentication credentials from the client.";
    };
    authorizedUsersFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the configuration file containing authorized users credentials to run iperf tests.";
    };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra flags to pass to iperf3(1).";
    };
  };

  imp = {

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.iperf3 = {
      description = "iperf3 daemon";
      unitConfig.Documentation = "man:iperf3(1) https://iperf.fr/iperf-doc.php";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 2;
        DynamicUser = true;
        PrivateDevices = true;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --server \
            --port ${toString cfg.port} \
            ${lib.optionalString (cfg.affinity != null) "--affinity ${toString cfg.affinity}"} \
            ${lib.optionalString (cfg.bind != null) "--bind ${cfg.bind}"} \
            ${lib.optionalString (cfg.rsaPrivateKey != null) "--rsa-private-key-path ${cfg.rsaPrivateKey}"} \
            ${
              lib.optionalString (
                cfg.authorizedUsersFile != null
              ) "--authorized-users-path ${cfg.authorizedUsersFile}"
            } \
            ${lib.optionalString cfg.verbose "--verbose"} \
            ${lib.optionalString cfg.debug "--debug"} \
            ${lib.optionalString cfg.forceFlush "--forceflush"} \
            ${lib.escapeShellArgs cfg.extraFlags}
        '';
      };
    };
  };
in
{
  options.services.iperf3 = api;
  config = lib.mkIf cfg.enable imp;
}
