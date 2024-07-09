{ config, lib, pkgs, ... }:

let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    ;
  cfg = config.services.tailscaleAuth;
in
{
  options.services.tailscaleAuth = {
    enable = mkEnableOption "tailscale.nginx-auth, to authenticate users via tailscale";

    package = mkPackageOption pkgs "tailscale-nginx-auth" {};

    user = mkOption {
      type = types.str;
      default = "tailscale-nginx-auth";
      description = "User which runs tailscale-nginx-auth";
    };

    group = mkOption {
      type = types.str;
      default = "tailscale-nginx-auth";
      description = "Group which runs tailscale-nginx-auth";
    };

    socketPath = mkOption {
      default = "/run/tailscale-nginx-auth/tailscale-nginx-auth.sock";
      type = types.path;
      description = ''
        Path of the socket listening to authorization requests.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
    };
    users.groups.${cfg.group} = { };

    systemd.sockets.tailscale-nginx-auth = {
      description = "Tailscale NGINX Authentication socket";
      partOf = [ "tailscale-nginx-auth.service" ];
      wantedBy = [ "sockets.target" ];
      listenStreams = [ cfg.socketPath ];
      socketConfig = {
        SocketMode = "0660";
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
      };
    };

    systemd.services.tailscale-nginx-auth = {
      description = "Tailscale NGINX Authentication service";
      requires = [ "tailscale-nginx-auth.socket" ];

      serviceConfig = {
        ExecStart = getExe cfg.package;
        RuntimeDirectory = "tailscale-nginx-auth";
        User = cfg.user;
        Group = cfg.group;

        BindPaths = [ "/run/tailscale/tailscaled.sock" ];

        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation" "~@debug" "~@keyring" "~@memlock" "~@obsolete" "~@privileged" "~@setuid"
        ];
      };
    };
  };

  meta.maintainers = with maintainers; [ dan-theriault phaer ];
}
