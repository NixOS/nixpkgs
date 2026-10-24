{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.gomodel;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.gomodel = {
    enable = lib.mkEnableOption "GoModel AI gateway";

    package = lib.mkPackageOption pkgs "gomodel" { };

    stateDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/gomodel";
      description = "State directory for GoModel (sqlite database, pid file, media, cache).";
    };

    port = lib.mkOption {
      type = types.port;
      default = 8080;
      description = "Port which the GoModel HTTP server listens on.";
    };

    settings = lib.mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          port = lib.mkOption {
            type = types.nullOr types.port;
            default = null;
            description = ''
              Port which the GoModel HTTP server listens on.
              If `null` (the default), the value of `services.gomodel.port` is used.
            '';
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          providers = [
            {
              name = "openai";
              type = "openai";
              api_key = "<your-api-key>";
            }
          ];
        }
      '';
      description = ''
        GoModel configuration, written to `config.yaml`.
        See <https://github.com/ENTERPILOT/GoModel> for the available keys.
      '';
    };

    environmentFiles = lib.mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          "/run/secrets/gomodel.env"
          "/run/secrets/gomodel-providers.env"
        ]
      '';
      description = ''
        Environment files passed to the systemd unit via the
        `EnvironmentFile=` directive. Multiple files are accepted and
        applied in the order given, so later files override earlier ones
        for any variable they both set. Useful for passing secrets to
        the service without baking them into the Nix store.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for GoModel.
        This adds `services.gomodel.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' 0700 - - - -" ];

    systemd.services.gomodel = {
      description = "GoModel AI gateway";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig =
        let
          # `settings.port` is a top-level convenience that maps to
          # `server.port` in the YAML schema. The PORT environment variable
          # is the highest-precedence source for the listen port (it is set
          # unconditionally from `services.gomodel.port` above), so we only
          # write `server.port` when the user explicitly opted in via
          # `settings.port`. Anything else in `cfg.settings` is preserved.
          # The top-level `port` key has to be removed before serialization
          # — otherwise the submodule's `port = null` default leaks into the
          # YAML and GoModel's strict parser rejects it as an unknown field.
          configFile =
            let
              settingsWithoutPort = removeAttrs cfg.settings [ "port" ];
              serverPortOverlay = lib.optionalAttrs (cfg.settings.port != null) {
                server.port = cfg.settings.port;
              };
            in
            settingsFormat.generate "gomodel-config.yaml" (settingsWithoutPort // serverPortOverlay);
        in
        {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "gomodel";
          StateDirectoryMode = "0700";
          WorkingDirectory = cfg.stateDir;
          ExecStartPre = [
            "-${cfg.package}/bin/gomodel -version"
            # GoModel auto-discovers `config.yaml` in the working directory
            # (see `configFilePaths` in the upstream `config` package). It
            # accepts no `-config` flag, so we expose the rendered YAML at
            # `${cfg.stateDir}/config.yaml`. The source is already in the
            # Nix store as a world-readable 0444 file, so a symlink avoids
            # the ownership problem of an `install` run that lands on the
            # host filesystem with a different uid than the dynamic user.
            "+${pkgs.coreutils}/bin/ln -sfT ${configFile} ${cfg.stateDir}/config.yaml"
          ];
          ExecStart = lib.getExe cfg.package;
          # Per systemd.exec(5), `Environment=` overrides `EnvironmentFile=`
          # for any variable both define, so the operator port always wins.
          # Change it via `services.gomodel.port` (or
          # `services.gomodel.settings.port` for the YAML schema); the user's
          # `environmentFiles` are reserved for secrets such as API keys
          # that don't have a Nix-level knob.
          Environment = "PORT=${toString cfg.port}";
          EnvironmentFile = cfg.environmentFiles;
          Restart = "on-failure";
          RestartSec = 5;

          # Hardening
          CapabilityBoundingSet = [ "" ];
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          UMask = "0077";
        };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = [ lib.maintainers.ser ];
}
