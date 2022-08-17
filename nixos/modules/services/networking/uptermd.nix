{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.uptermd;
in
{
  options = {
    services.uptermd = {
      enable = mkEnableOption "uptermd";

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open the firewall for the port in {option}`services.uptermd.port`.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 2222;
        description = lib.mdDoc ''
          Port the server will listen on.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "[::]";
        example = "127.0.0.1";
        description = lib.mdDoc ''
          Address the server will listen on.
        '';
      };

      hostKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/upterm_host_ed25519_key";
        description = lib.mdDoc ''
          Path to SSH host key. If not defined, an ed25519 keypair is generated automatically.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--debug" ];
        description = lib.mdDoc ''
          Extra flags passed to the uptermd command.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.uptermd = {
      description = "Upterm Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      path = [ pkgs.openssh ];

      preStart = mkIf (cfg.hostKey == null) ''
        if ! [ -f ssh_host_ed25519_key ]; then
          ssh-keygen \
            -t ed25519 \
            -f ssh_host_ed25519_key \
            -N ""
        fi
      '';

      serviceConfig = {
        StateDirectory = "uptermd";
        WorkingDirectory = "/var/lib/uptermd";
        ExecStart = "${pkgs.upterm}/bin/uptermd --ssh-addr ${cfg.listenAddress}:${toString cfg.port} --private-key ${if cfg.hostKey == null then "ssh_host_ed25519_key" else cfg.hostKey} ${concatStringsSep " " cfg.extraFlags}";

        # Hardening
        AmbientCapabilities = mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        PrivateUsers = cfg.port >= 1024;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        # AF_UNIX is for ssh-keygen, which relies on nscd to resolve the uid to a user
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };
  };
}
