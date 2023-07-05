{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.distccd;
in
{
  options = {
    services.distccd = {
      enable = mkEnableOption (lib.mdDoc "distccd");

      allowedClients = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        example = [ "127.0.0.1" "192.168.0.0/24" "10.0.0.0/24" ];
        description = lib.mdDoc ''
          Client IPs which are allowed to connect to distccd in CIDR notation.

          Anyone who can connect to the distccd server can run arbitrary
          commands on that system as the distcc user, therefore you should use
          this judiciously.
        '';
      };

      jobTimeout = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Maximum duration, in seconds, of a single compilation request.
        '';
      };

      logLevel = mkOption {
        type = types.nullOr (types.enum [ "critical" "error" "warning" "notice" "info" "debug" ]);
        default = "warning";
        description = lib.mdDoc ''
          Set the minimum severity of error that will be included in the log
          file. Useful if you only want to see error messages rather than an
          entry for each connection.
        '';
      };

      maxJobs = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Maximum number of tasks distccd should execute at any time.
        '';
      };


      nice = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Niceness of the compilation tasks.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Opens the specified TCP port for distcc.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.distcc;
        defaultText = literalExpression "pkgs.distcc";
        description = lib.mdDoc ''
          The distcc package to use.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 3632;
        description = lib.mdDoc ''
          The TCP port which distccd will listen on.
        '';
      };

      stats = {
        enable = mkEnableOption (lib.mdDoc "statistics reporting via HTTP server");
        port = mkOption {
          type = types.port;
          default = 3633;
          description = lib.mdDoc ''
            The TCP port which the distccd statistics HTTP server will listen
            on.
          '';
        };
      };

      zeroconf = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to register via mDNS/DNS-SD
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ]
        ++ optionals cfg.stats.enable [ cfg.stats.port ];
    };

    systemd.services.distccd = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      description = "Distributed C, C++ and Objective-C compiler";
      documentation = [ "man:distccd(1)" ];

      serviceConfig = {
        User = "distcc";
        Group = "distcc";
        # FIXME: I'd love to get rid of `--enable-tcp-insecure` here, but I'm
        # not sure how I'm supposed to get distccd to "accept" running a binary
        # (the compiler) that's outside of /usr/lib.
        ExecStart = pkgs.writeShellScript "start-distccd" ''
          export PATH="${pkgs.distccMasquerade}/bin"
          ${cfg.package}/bin/distccd \
            --no-detach \
            --daemon \
            --enable-tcp-insecure \
            --port ${toString cfg.port} \
            ${optionalString (cfg.jobTimeout != null) "--job-lifetime ${toString cfg.jobTimeout}"} \
            ${optionalString (cfg.logLevel != null) "--log-level ${cfg.logLevel}"} \
            ${optionalString (cfg.maxJobs != null) "--jobs ${toString cfg.maxJobs}"} \
            ${optionalString (cfg.nice != null) "--nice ${toString cfg.nice}"} \
            ${optionalString cfg.stats.enable "--stats"} \
            ${optionalString cfg.stats.enable "--stats-port ${toString cfg.stats.port}"} \
            ${optionalString cfg.zeroconf "--zeroconf"} \
            ${concatMapStrings (c: "--allow ${c} ") cfg.allowedClients}
        '';
      };
    };

    users = {
      groups.distcc.gid = config.ids.gids.distcc;
      users.distcc = {
        description = "distccd user";
        group = "distcc";
        uid = config.ids.uids.distcc;
      };
    };
  };
}
