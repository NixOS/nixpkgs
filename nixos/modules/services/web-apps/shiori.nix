{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.shiori;
in {
  options = {
    services.shiori = {
      enable = mkEnableOption "Shiori simple bookmarks manager";

      package = mkOption {
        type = types.package;
        default = pkgs.shiori;
        defaultText = "pkgs.shiori";
        description = "The Shiori package to use.";
      };

      address = mkOption {
        type = types.str;
        default = "";
        description = ''
          The IP address on which Shiori will listen.
          If empty, listens on all interfaces.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "The port of the Shiori web application";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.shiori = with cfg; {
      description = "Shiori simple bookmarks manager";
      wantedBy = [ "multi-user.target" ];

      environment.SHIORI_DIR = "/var/lib/shiori";

      serviceConfig = {
        ExecStart = "${package}/bin/shiori serve --address '${address}' --port '${toString port}'";

        DynamicUser = true;
        StateDirectory = "shiori";
        # As the RootDirectory
        RuntimeDirectory = "shiori";

        # Security options

        BindReadOnlyPaths = [
          "/nix/store"

          # For SSL certificates, and the resolv.conf
          "/etc"
        ];

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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        RootDirectory = "/run/shiori";

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"

          "~@chown" "~@cpu-emulation" "~@debug" "~@ipc" "~@keyring" "~@memlock"
          "~@module" "~@obsolete" "~@privileged" "~@process" "~@raw-io"
          "~@resources" "~@setuid"
        ];
      };
    };
  };

  meta.maintainers = with maintainers; [ minijackson ];
}
