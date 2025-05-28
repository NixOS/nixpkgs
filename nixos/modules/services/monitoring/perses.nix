{
  pkgs,
  lib,
  config,
  utils,
  ...
}:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    types
    ;

  cfg = config.services.perses;

  settingsFormat = pkgs.formats.yaml { };

in
{
  options.services.perses = {
    enable = mkEnableOption "perses";

    package = mkPackageOption pkgs "perses" { };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Perses Web interface port.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "";
      description = ''
        Address to listen on. Empty string will listen on all interfaces.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      description = ''
        Perses settings. See <https://perses.dev/perses/docs/configuration/configuration/> for available options.
        You can specify secret values in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
      '';
      default = { };
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "-web.telemetry-path=/metrics"
      ];
      description = "Additional options passed to perses daemon.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.perses = {
      description = "Perses Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      preStart = ''
        # Generate config including secret values.
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/perses/config.yaml"}
      '';

      serviceConfig = rec {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "-config=/run/perses/config.yaml"
            "-web.listen-address=${cfg.listenAddress}:${toString cfg.port}"
          ]
          ++ cfg.extraOptions
        );

        User = "perses";
        DynamicUser = true;
        Restart = "on-failure";
        RuntimeDirectory = "perses";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "perses";
        WorkingDirectory = "%S/${StateDirectory}";

        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0027";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
