{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.scrobblex;
  pkg = cfg.package;
  stateDir = "/var/lib/scrobblex";
in
{
  meta.maintainers = with lib.maintainers; [ msaxena ];

  options.services.scrobblex = {
    enable = lib.mkEnableOption "Scrobblex, a self-hosted Plex-to-Trakt scrobbler";

    package = lib.mkPackageOption pkgs "scrobblex" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3090;
      description = "TCP port scrobblex listens on.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "error"
        "warn"
        "info"
        "http"
        "verbose"
        "debug"
        "silly"
      ];
      default = "info";
      description = "Log level (Winston).";
    };

    plexUser = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "alice"
        "bob"
      ];
      description = ''
        Plex usernames whose webhook events are accepted.
        An empty list (the default) allows all users through.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/scrobblex";
      description = ''
        Path to a file containing secret environment variables, loaded by
        systemd before the service starts. Must define at minimum:

        ```
        TRAKT_ID=your-trakt-client-id
        TRAKT_SECRET=your-trakt-client-secret
        ```

        Use [agenix](https://github.com/ryantm/agenix) or
        [sops-nix](https://github.com/Mic92/sops-nix) to keep secrets out
        of the Nix store.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open {option}`services.scrobblex.port` in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.scrobblex = {
      description = "Scrobblex Plex-to-Trakt scrobbler";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PORT = toString cfg.port;
        LOG_LEVEL = cfg.logLevel;
      }
      // lib.optionalAttrs (cfg.plexUser != [ ]) {
        PLEX_USER = lib.concatStringsSep "," cfg.plexUser;
      };

      serviceConfig = {
        Type = "simple";

        DynamicUser = true;

        # Creates and owns /var/lib/scrobblex.
        StateDirectory = "scrobblex";
        StateDirectoryMode = "0700";

        # The app resolves all paths (./data, ./static, ./views, ./favicon.ico)
        # relative to process.cwd(). Set CWD to the writable state directory
        # and symlink the read-only store assets in on startup.
        WorkingDirectory = stateDir;

        ExecStartPre = pkgs.writeShellScript "scrobblex-prestart" ''
          ln -sfn ${pkg}/lib/scrobblex/static    ${stateDir}/static
          ln -sfn ${pkg}/lib/scrobblex/views     ${stateDir}/views
          ln -sfn ${pkg}/lib/scrobblex/favicon.ico ${stateDir}/favicon.ico
        '';

        # Run node directly so WorkingDirectory is respected rather than
        # the CWD baked into the package wrapper.
        ExecStart = "${lib.getExe pkgs.nodejs} ${pkg}/lib/scrobblex/src/index.js";

        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          # libuv uses AF_NETLINK (NETLINK_ROUTE) to query network interfaces
          # for Node.js os.networkInterfaces(); without it the process crashes.
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        # Node.js JIT requires writable+executable memory mappings.
        MemoryDenyWriteExecute = false;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        ReadWritePaths = [ stateDir ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
