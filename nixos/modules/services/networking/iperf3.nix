{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.iperf3;

  api = {
    enable = mkEnableOption "iperf3 network throughput testing server";
    port = mkOption {
      type        = types.ints.u16;
      default     = 5201;
      description = "Server port to listen on for iperf3 client requests.";
    };
    affinity = mkOption {
      type        = types.nullOr types.ints.unsigned;
      default     = null;
      description = "CPU affinity for the process.";
    };
    bind = mkOption {
      type        = types.nullOr types.str;
      default     = null;
      description = "Bind to the specific interface associated with the given address.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall for iperf3.";
    };
    verbose = mkOption {
      type        = types.bool;
      default     = false;
      description = "Give more detailed output.";
    };
    forceFlush = mkOption {
      type        = types.bool;
      default     = false;
      description = "Force flushing output at every interval.";
    };
    debug = mkOption {
      type        = types.bool;
      default     = false;
      description = "Emit debugging output.";
    };
    rsaPrivateKey = mkOption {
      type        = types.nullOr types.path;
      default     = null;
      description = "Path to the RSA private key (not password-protected) used to decrypt authentication credentials from the client.";
    };
    authorizedUsersFile = mkOption {
      type        = types.nullOr types.path;
      default     = null;
      description = "Path to the configuration file containing authorized users credentials to run iperf tests.";
    };
    extraFlags = mkOption {
      type        = types.listOf types.str;
      default     = [ ];
      description = "Extra flags to pass to iperf3(1).";
    };
  };

  imp = {

    networking.firewall = mkIf cfg.openFirewall {
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
          ${pkgs.iperf3}/bin/iperf \
            --server \
            --port ${toString cfg.port} \
            ${optionalString (cfg.affinity != null) "--affinity ${toString cfg.affinity}"} \
            ${optionalString (cfg.bind != null) "--bind ${cfg.bind}"} \
            ${optionalString (cfg.rsaPrivateKey != null) "--rsa-private-key-path ${cfg.rsaPrivateKey}"} \
            ${optionalString (cfg.authorizedUsersFile != null) "--authorized-users-path ${cfg.authorizedUsersFile}"} \
            ${optionalString cfg.verbose "--verbose"} \
            ${optionalString cfg.debug "--debug"} \
            ${optionalString cfg.forceFlush "--forceflush"} \
            ${escapeShellArgs cfg.extraFlags}
        '';
      };
    };
  };
in {
  options.services.iperf3 = api;
  config = mkIf cfg.enable imp;
}
