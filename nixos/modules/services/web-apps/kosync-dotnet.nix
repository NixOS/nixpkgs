{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kosync-dotnet;

  # The database path is hardcoded relative to the working directory as
  # `data/Kosync.db`, so the service is run from its state directory.
  stateDir = "/var/lib/kosync-dotnet";

  startScript = pkgs.writeShellScript "kosync-dotnet-start" ''
    ${lib.optionalString (cfg.adminPasswordFile != null) ''
      ADMIN_PASSWORD="$(< "$CREDENTIALS_DIRECTORY/admin-password")"
      export ADMIN_PASSWORD
    ''}
    exec ${lib.getExe cfg.package}
  '';
in
{
  options.services.kosync-dotnet = {
    enable = lib.mkEnableOption "kosync-dotnet, a self-hostable KOReader sync server";

    package = lib.mkPackageOption pkgs "kosync-dotnet" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        Port on which kosync-dotnet listens for HTTP requests.

        The server speaks plain HTTP only; put it behind a reverse proxy to
        terminate TLS.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open {option}`services.kosync-dotnet.port` in the firewall.
      '';
    };

    adminPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/kosync-admin-password";
      description = ''
        Path to a file containing the password of the `admin` account, which
        is required by the management API.

        The password is re-applied from this file on every start, so changing
        it through the management API will not persist across restarts.

        If left at `null`, upstream's default password `admin` is used, which
        is unsafe for any server reachable from a network.
      '';
    };

    registrationDisabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to refuse new user registrations. Recommended for publicly
        reachable servers; the management API can still create users.
      '';
    };

    trustedProxies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "127.0.0.1"
        "::1"
        "10.0.0.0/24"
      ];
      description = ''
        Addresses or CIDR subnets of reverse proxies whose `X-Forwarded-For`
        header is trusted to carry the real client address for logging.

        Requests that do not arrive through one of these are logged with the
        connecting address instead, marked with an asterisk.
      '';
    };

    singleLineLogging = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to emit each log entry on a single line, which reads better in
        the journal than the multi-line ASP.NET Core default.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/kosync-dotnet.env";
      description = ''
        Path to an environment file, in the format understood by systemd's
        {manpage}`systemd.exec(5)` `EnvironmentFile`, passed to the service.

        Useful for settings that should be kept out of the world-readable Nix
        store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (cfg.adminPasswordFile == null) ''
      services.kosync-dotnet.adminPasswordFile is not set, so the admin account
      uses the default password `admin`. Set it to a file containing a strong
      password before exposing this server to a network.
    '';

    systemd.services.kosync-dotnet = {
      description = "kosync-dotnet KOReader sync server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        ASPNETCORE_HTTP_PORTS = toString cfg.port;
        DOTNET_EnableDiagnostics = "0";
      }
      // lib.optionalAttrs cfg.registrationDisabled {
        REGISTRATION_DISABLED = "true";
      }
      // lib.optionalAttrs cfg.singleLineLogging {
        SINGLE_LINE_LOGGING = "true";
      }
      // lib.optionalAttrs (cfg.trustedProxies != [ ]) {
        TRUSTED_PROXIES = lib.concatStringsSep "," cfg.trustedProxies;
      };

      serviceConfig = {
        ExecStart = startScript;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = lib.optional (
          cfg.adminPasswordFile != null
        ) "admin-password:${cfg.adminPasswordFile}";

        DynamicUser = true;
        StateDirectory = "kosync-dotnet";
        StateDirectoryMode = "0700";
        WorkingDirectory = stateDir;
        Restart = "on-failure";

        AmbientCapabilities = lib.optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = if cfg.port < 1024 then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];

        DevicePolicy = "closed";
        LockPersonality = true;
        # The .NET runtime JIT needs writable-executable mappings.
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
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
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ notthebee ];
}
