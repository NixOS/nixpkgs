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
in
{
  options.services.autokuma = {
    enable = lib.mkEnableOption "autokuma";
    docker = {
      enable = lib.mkEnableOption "reading monitor configuration from docker labels; will add autokuma user to docker / podman group which would allow it to gain root, use services.uptime-kuma.docker.addGroups = false; to disable";
      addGroups = lib.mkOption {
        description = "add autokuma user to docker/podman groups if docker/podman is enabled locally";
        default = true;
        type = lib.types.bool;
      };
      hosts = lib.mkOption {
        type =
          with lib.types;
          oneOf [
            str
            (listOf str)
            (listOf (attrsOf str))
          ];
        default = [ ];
        description = ''
          docker hosts to watch for container labels, either a semicolon-separated string, a list of strings or a list of attrsets according to https://github.com/BigBoot/AutoKuma
                  will be set to the docker and/or podman sockets if the respective service is enabled'';
      };
    };
    package = lib.mkPackageOption pkgs "autokuma" { };

    localUptimeKuma = lib.mkOption {
      description = "use local uptime-kuma.service as After; set automatically if service.uptime-kuma.enable";
      type = lib.types.bool;
      default = false;
    };

    settings = lib.mkOption {
      description = "settings for autokuma, passed as environment variables. do not set secrets here; use proper secret management using services.autokuma.environmentFile";
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = { };
    };
    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "file with environment variables passed to the systemd service, see systemd documentation for format";
    };

    staticMonitorsDir = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "the directory in which static monitor definitions reside. set per default to static monitor directory generated from services.autokuma.staticMonitors, can be set to a custom directory with files placed manually";
    };

    staticMonitors = lib.mkOption {
      description = "every element of this list is a file, containing an array of static monitors, see https://github.com/BigBoot/AutoKuma/blob/master/monitors for examples. for example `{thefile = [{...}]} is written to a file called `thefile.json`, so if one wants to use the first defined item (e. g. group), one needs to use `\"thefile[0]\"`. this is very jank but autokuma doesn't support anything else afaik";
      type = with lib.types; attrsOf (listOf attrs);
      default = { };
    };

    kumaUrl = lib.mkOption {
      description = "the url of the uptime kuma instance to access";
      type = lib.types.str;
      default = "";
    };
    kumaUser = lib.mkOption {
      description = "the username of the uptime kuma instance to access";
      type = lib.types.str;
      default = "";
    };
    kumaPassword = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "the password of the uptime kuma instance to access; do not use this field to set the password in production because it will be world readable; use proper secret management, this is just for testing";
    };
  };

  config = lib.mkIf cfg.enable {
    services.autokuma = {
      docker.hosts =
        (
          if config.virtualisation.docker.enable then
            builtins.map (
              s: if lib.strings.hasPrefix "/" s then "unix://${s}" else s
            ) config.virtualisation.docker.listenOptions
          else
            [ ]
        )
        ++ (lib.optional config.virtualisation.podman.enable "/run/podman/podman.sock");
      localUptimeKuma = config.services.uptime-kuma.enable;
      staticMonitorsDir = if cfg.staticMonitors == { } then "" else monitorDir.outPath;
      settings = {
        AUTOKUMA__STATIC_MONITORS = cfg.staticMonitorsDir;
        AUTOKUMA__KUMA__URL = cfg.kumaUrl;
        AUTOKUMA__KUMA__USERNAME = cfg.kumaUser;
        AUTOKUMA__KUMA__PASSWORD = cfg.kumaPassword;
        AUTOKUMA__DOCKER__ENABLED = if cfg.docker.enable then "true" else "false";
        AUTOKUMA__DOCKER__HOSTS =
          if lib.isString cfg.docker.hosts then
            cfg.docker.hosts
          else if lib.isList cfg.docker.hosts then
            if cfg.docker.hosts == [ ] then
              ""
            else if lib.isString (builtins.elemAt cfg.docker.hosts 0) then
              lib.join ";" cfg.docker.hosts
            else
              builtins.toJSON cfg.docker.hosts
          else
            "";
        AUTOKUMA__FILES__ENABLED = if cfg.staticMonitorsDir == "" then "false" else "true";
        AUTOKUMA__LOG_DIR = "/var/log/autokuma"; # set for systemd LogsDirectory to work
        XDG_CONFIG_HOME = "/etc"; # set for systemd ConfigurationDirectory to work
      };
    };

    systemd.services.autokuma = {
      description = "Autokuma";
      after = [ "network.target" ] ++ lib.optionals cfg.localUptimeKuma [ "uptime-kuma.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = cfg.environmentFile;

        ExecStart = "${cfg.package.outPath}/bin/autokuma";
        Restart = "on-failure";

        DynamicUser = true;
        SupplementaryGroups =
          lib.optionals (cfg.docker.enable && cfg.docker.addGroups && config.virtualisation.docker.enable) [
            "docker"
          ]
          ++ lib.optionals (
            cfg.docker.enable && cfg.docker.addGroups && config.virtualisation.podman.enable
          ) [ "podman" ];
        LogsDirectory = "autokuma";
        ConfigurationDirectory = "autokuma";
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
