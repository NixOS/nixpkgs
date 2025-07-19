{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    getExe'
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    mkDefault
    ;

  inherit (lib.types)
    port
    str
    attrsOf
    bool
    either
    submodule
    path
    ;

  cfg = config.services.netbird.server.relay;
in

{
  options.services.netbird.server.relay = {
    enable = mkEnableOption "Netbird's Relay Service";

    package = mkPackageOption pkgs "netbird-server" { };

    port = mkOption {
      type = port;
      default = 33080;
      description = "Internal port of the relay server.";
    };

    settings = mkOption {
      type = submodule {
        freeformType = attrsOf (either str bool);
        options.NB_EXPOSED_ADDRESS = mkOption {
          type = str;
          description = ''
            The public address of this peer, to be distribute as part of relay operations.
          '';
        };
      };

      defaultText = ''
        {
          NB_LISTEN_ADDRESS = ":''${builtins.toString cfg.port}";
          NB_METRICS_PORT = "9092";
        }
      '';

      description = ''
        An attribute set that will be set as the environment for the process.
        Used for runtime configuration.
        The exact values sadly aren't documented anywhere.
        A starting point when searching for valid values is this [source file](https://github.com/netbirdio/netbird/blob/main/relay/cmd/root.go).
      '';
    };

    authSecretFile = mkOption {
      type = path;
      description = ''
        The path to a file containing the auth-secret used by netbird to connect to the relay server.
      '';
    };

  };

  config = mkIf cfg.enable {
    services.netbird.server.relay.settings = {
      NB_LISTEN_ADDRESS = mkDefault ":${builtins.toString cfg.port}";
      NB_METRICS_PORT = mkDefault "9092"; # Upstream default is 9090 but this would clash for nixos where all services run on the same host
    };
    systemd.services.netbird-relay = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;

      script = ''
        export NB_AUTH_SECRET="$(<${cfg.authSecretFile})"
        ${getExe' cfg.package "netbird-relay"}
      '';
      serviceConfig = {

        Restart = "always";
        RuntimeDirectory = "netbird-mgmt";
        StateDirectory = "netbird-mgmt";
        WorkingDirectory = "/var/lib/netbird-mgmt";

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };

      stopIfChanged = false;
    };
  };
}
