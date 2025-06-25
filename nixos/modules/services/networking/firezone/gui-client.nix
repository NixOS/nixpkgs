{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.firezone.gui-client;
in
{
  options = {
    services.firezone.gui-client = {
      enable = mkEnableOption "the firezone gui client";
      package = mkPackageOption pkgs "firezone-gui-client" { };

      allowedUsers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          All listed users will become part of the `firezone-client` group so
          they can control the tunnel service. This is a convenience option.
        '';
      };

      name = mkOption {
        type = types.str;
        description = "The name of this client as shown in firezone";
      };

      logLevel = mkOption {
        type = types.str;
        default = "info";
        description = ''
          The log level for the firezone application. See
          [RUST_LOG](https://docs.rs/env_logger/latest/env_logger/#enabling-logging)
          for the format.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.firezone-client.members = cfg.allowedUsers;

    # Required for deep-link mimetype registration
    environment.systemPackages = [ cfg.package ];

    # Required for the token store in the gui application
    services.gnome.gnome-keyring.enable = true;

    systemd.services.firezone-tunnel-service = {
      description = "GUI tunnel service for the Firezone zero-trust access platform";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.util-linux ];
      script = ''
        # If FIREZONE_ID is not given by the user, use a persisted (or newly generated) uuid.
        if [[ -z "''${FIREZONE_ID:-}" ]]; then
          if [[ ! -e client_id ]]; then
            uuidgen -r > client_id
          fi
          export FIREZONE_ID=$(< client_id)
        fi

        exec ${getExe' cfg.package "firezone-client-tunnel"} run
      '';

      environment = {
        FIREZONE_NAME = cfg.name;
        LOG_DIR = "%L/dev.firezone.client";
        RUST_LOG = cfg.logLevel;
      };

      serviceConfig = {
        Type = "notify";

        DeviceAllow = "/dev/net/tun";
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];

        # This block contains hardcoded values in the client, we cannot change these :(
        Group = "firezone-client";
        RuntimeDirectory = "dev.firezone.client";
        StateDirectory = "dev.firezone.client";
        WorkingDirectory = "/var/lib/dev.firezone.client";
        LogsDirectory = "dev.firezone.client";

        Restart = "on-failure";
        RestartSec = 10;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    oddlama
    patrickdag
  ];
}
