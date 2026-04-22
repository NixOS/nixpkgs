{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.autokuma;
  monitorDir = pkgs.callPackage (
    { runCommand, jq }:
    runCommand "autokuma-monitors"
      {
        nativeBuildInputs = [ jq ];
        value = builtins.toJSON cfg.staticMonitors;
        passAsFile = [ "value" ];
        preferLocalBuild = true;
      }
      ''
        mkdir $out
        jq -rc "to_entries | .[] | [.key,.value] | .[]" $valuePath | while IFS= read -r filename ; do
          IFS= read -r content
          echo "$content" > "$out/$filename.json"
        done
      ''
  ) { };
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.autokuma = {
    enable = lib.mkEnableOption "autokuma";
    package = lib.mkPackageOption pkgs "autokuma" { };

    localUptimeKuma = lib.mkOption {
      description = "use local uptime-kuma.service as After; set automatically if service.uptime-kuma.enable";
      type = lib.types.bool;
      default = false;
    };
    dockerAddToGroups = lib.mkOption {
      description = "add autokuma user to docker/podman groups if docker/podman is enabled locally";
      default = true;
      type = lib.types.bool;
    };
    staticMonitors = lib.mkOption {
      description = "every element of this list is a file, containing an array of static monitors, see https://github.com/BigBoot/AutoKuma/blob/master/monitors for examples. for example `{thefile = [{...}]} is written to a file called `thefile.json`, so if one wants to use the first defined item (e. g. group), one needs to use `\"thefile[0]\"`. this is very jank but autokuma doesn't support anything else afaik";
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };

    settings = lib.mkOption {
      description = "settings for autokuma, passed in a config file. do not set secrets here; use proper secret management using services.autokuma.environmentFile";
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          kuma = {
            url = lib.mkOption {
              description = "the url of the uptime kuma instance to access";
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            username = lib.mkOption {
              description = "the username of the uptime kuma instance to access";
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            password = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "the password of the uptime kuma instance to access; do not use this field to set the password in production because it will be world readable; use proper secret management, this is just for testing";
            };
          };

          static_monitors = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "the directory in which static monitor definitions reside. set per default to static monitor directory generated from services.autokuma.staticMonitors, can be set to a custom directory with files placed manually";
          };

          docker = {
            enabled = lib.mkEnableOption "reading monitor configuration from docker labels; will add autokuma user to docker / podman group which would allow it to gain root, use services.uptime-kuma.docker.addGroups = false; to disable";
            hosts = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.oneOf [
                  lib.types.str
                  (lib.types.listOf lib.types.str)
                  (lib.types.listOf (lib.types.attrsOf lib.types.str))
                ]
              );
              default = null;
              description = ''
                docker hosts to watch for container labels, either a semicolon-separated string, a list of strings or a list of attrsets according to https://github.com/BigBoot/AutoKuma
                        will be set to the docker and/or podman sockets if the respective service is enabled'';
            };
          };
        };
      };
      default = { };
    };
    environmentFile = lib.mkOption {
      type = lib.types.oneOf [
        lib.types.str
        (lib.types.listOf lib.types.str)
      ];
      default = "";
      description = "file with environment variables passed to the systemd service, see systemd documentation for format";
    };
  };

  config = lib.mkIf cfg.enable {
    services.autokuma = {
      localUptimeKuma = lib.mkDefault config.services.uptime-kuma.enable;
      settings = {
        # set for systemd LogsDirectory to work
        log_dir = "/var/log/autokuma";
        # set for systemd StateDirectory to work
        data_path = "/var/lib/autokuma";
        docker.hosts = lib.mkDefault (
          (
            if config.virtualisation.docker.enable then
              builtins.map (
                s: if lib.strings.hasPrefix "/" s then "unix://${s}" else s
              ) config.virtualisation.docker.listenOptions
            else
              [ ]
          )
          ++ (lib.optional config.virtualisation.podman.enable "unix:///run/podman/podman.sock")
        );
        static_monitors = lib.mkDefault (if cfg.staticMonitors == { } then null else monitorDir.outPath);
        files.enabled = lib.mkDefault (toString cfg.settings.static_monitors != "");
      };
    };

    environment.etc."autokuma/config.json" = {
      source = settingsFormat.generate "config.json" cfg.settings;
      mode = "444";
    };

    systemd.services.autokuma = {
      description = "Autokuma";
      after = [ "network.target" ] ++ lib.optionals cfg.localUptimeKuma [ "uptime-kuma.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.XDG_CONFIG_HOME = "/etc"; # set for systemd ConfigurationDirectory to work

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = cfg.environmentFile;

        ExecStart = "${cfg.package.outPath}/bin/autokuma";
        Restart = "on-failure";

        SupplementaryGroups =
          lib.optionals
            (cfg.settings.docker.enabled && cfg.dockerAddToGroups && config.virtualisation.docker.enable)
            [
              "docker"
            ]
          ++ lib.optionals (
            cfg.settings.docker.enabled && cfg.dockerAddToGroups && config.virtualisation.podman.enable
          ) [ "podman" ];
        DynamicUser = true;
        LogsDirectory = "autokuma";
        ConfigurationDirectory = "autokuma";
        StateDirectory = "autokuma";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
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
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 0027;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ kruemmelspalter ];
}
