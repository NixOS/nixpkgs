{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.harmonia;
  format = pkgs.formats.toml { };
in
{
  options = {
    services.harmonia = {
      enable = lib.mkEnableOption "Harmonia: Nix binary cache written in Rust";

      signKeyPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the signing key that will be used for signing the cache";
      };

      package = lib.mkPackageOption pkgs "harmonia" { };

      settings = lib.mkOption {
        inherit (format) type;
        default = { };
        description = ''
          Settings to merge with the default configuration.
          For the list of the default configuration, see <https://github.com/nix-community/harmonia/tree/master#configuration>.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.extra-allowed-users = [ "harmonia" ];
    users.users.harmonia = {
      isSystemUser = true;
      group = "harmonia";
    };
    users.groups.harmonia = { };

    systemd.services.harmonia = {
      description = "harmonia binary cache service";

      requires = [ "nix-daemon.socket" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        CONFIG_FILE = format.generate "harmonia.toml" cfg.settings;
        SIGN_KEY_PATH = lib.mkIf (cfg.signKeyPath != null) "%d/sign-key";
        # Note: it's important to set this for nix-store, because it wants to use
        # $HOME in order to use a temporary cache dir. bizarre failures will occur
        # otherwise
        HOME = "/run/harmonia";
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        User = "harmonia";
        Group = "harmonia";
        Restart = "on-failure";
        PrivateUsers = true;
        DeviceAllow = [ "" ];
        UMask = "0066";
        RuntimeDirectory = "harmonia";
        LoadCredential = lib.mkIf (cfg.signKeyPath != null) [ "sign-key:${cfg.signKeyPath}" ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        CapabilityBoundingSet = "";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        LockPersonality = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        LimitNOFILE = 65536;
      };
    };
  };
}
