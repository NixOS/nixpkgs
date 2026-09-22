{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.dufs;
  format = pkgs.formats.yaml { };
  reservedSettings = {
    bind = "bindAddresses";
    port = "port";
    "serve-path" = "servePath";
  };
  configFile = format.generate "dufs.yaml" (
    cfg.settings
    // {
      bind = cfg.bindAddresses;
      inherit (cfg) port;
      "serve-path" = cfg.servePath;
    }
  );
in
{
  options.services.dufs = {
    enable = lib.mkEnableOption "dufs file server";

    package = lib.mkPackageOption pkgs "dufs" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "dufs";
      description = "User account under which dufs runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "dufs";
      description = "Group under which dufs runs.";
    };

    servePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/dufs";
      description = ''
        Path served by dufs. The default path `/var/lib/dufs` is created
        automatically. Any other path must already exist and be accessible to
        the configured user and group.
      '';
    };

    bindAddresses = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.str;
      default = [ "127.0.0.1" ];
      example = [
        "127.0.0.1"
        "::1"
      ];
      description = "IP addresses on which dufs listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
      description = "TCP port on which dufs listens.";
    };

    openFirewall = lib.mkEnableOption "opening the dufs TCP port in the firewall";

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/dufs.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`. Use
        `DUFS_AUTH` in this file to keep authentication credentials out of the
        world-readable Nix store.
      '';
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      example = {
        allow-upload = true;
        allow-delete = true;
        compress = "low";
        hidden = [ "*.tmp" ];
      };
      description = ''
        Settings written to the dufs YAML configuration file. See the
        [dufs configuration documentation](https://github.com/sigoden/dufs#configuration-file)
        for available values. Configure `serve-path`, `bind`, and `port` with
        their dedicated NixOS options instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.mapAttrsToList (setting: option: {
      assertion = !(builtins.hasAttr setting cfg.settings);
      message = "services.dufs.settings.${setting} is managed by services.dufs.${option}.";
    }) reservedSettings;

    warnings = lib.optional (cfg.settings ? auth) ''
      services.dufs.settings.auth may expose credentials in the world-readable
      Nix store. Use services.dufs.environmentFile with DUFS_AUTH instead.
    '';

    users.users = lib.mkIf (cfg.user == "dufs") {
      dufs = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "dufs") {
      dufs = { };
    };

    systemd.services.dufs = {
      description = "dufs file server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--config"
          configFile
        ];
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = lib.mkIf (cfg.servePath == "/var/lib/dufs") "dufs";
        StateDirectoryMode = lib.mkIf (cfg.servePath == "/var/lib/dufs") "0750";
        ReadWritePaths = [ cfg.servePath ];
        UMask = "0077";
        NoNewPrivileges = true;
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if cfg.port < 1024 then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = [ lib.maintainers.font44 ];
}
