{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) literalExpression types;

  cfg = config.services.ollaya;
  ollaya = lib.getExe cfg.package;

  staticUser = cfg.user != null && cfg.group != null;
in
{
  options.services.ollaya = {
    enable = lib.mkEnableOption "ollaya server for local decision models";

    package = lib.mkPackageOption pkgs "ollaya" { };

    user = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ollaya";
      description = ''
        User account under which to run ollaya. Defaults to
        [`DynamicUser`](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=)
        when set to `null`.

        The user will automatically be created when this option is non-null.
      '';
    };

    group = lib.mkOption {
      type = types.nullOr types.str;
      default = cfg.user;
      defaultText = literalExpression "config.services.ollaya.user";
      example = "ollaya";
      description = ''
        Group under which to run ollaya. Only used when `services.ollaya.user` is set.
      '';
    };

    home = lib.mkOption {
      type = types.str;
      default = "/var/lib/ollaya";
      example = "/home/foo";
      description = "The home directory that the ollaya service is started in.";
    };

    modelsDir = lib.mkOption {
      type = types.str;
      default = "${cfg.home}/models";
      defaultText = literalExpression "\${config.services.ollaya.home}/models";
      example = "/path/to/ollaya/models";
      description = ''
        Directory where ollaya reads and stores downloaded models.
      '';
    };

    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "IP address on which the server listens.";
    };

    port = lib.mkOption {
      type = types.port;
      default = 11435;
      example = 11111;
      description = "Port on which the server listens.";
    };

    settings = lib.mkOption {
      type = types.submodule { freeformType = types.attrsOf types.str; };
      default = { };
      example = {
        OLLAYA_DEVICE = "cuda";
        OLLAYA_KEEP_ALIVE = "30m";
      };
      description = ''
        Environment variables passed to the ollaya server process.
        See <https://ollaya.dev/docs/cli#ollaya-serve> for available variables.
      '';
    };

    loadModels = lib.mkOption {
      type = types.listOf types.str;
      apply = builtins.filter (model: model != "");
      default = [ ];
      example = [ "winnow:e4b" ];
      description = ''
        Models to download after the ollaya service starts. This creates a
        separate `ollaya-model-loader.service`.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for ollaya. This adds
        `services.ollaya.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = lib.mkIf staticUser {
      users.${cfg.user} = {
        inherit (cfg) home;
        isSystemUser = true;
        group = cfg.group;
      };
      groups.${cfg.group} = { };
    };

    systemd.services.ollaya = {
      description = "Server for local decision models";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = cfg.settings // {
        HOME = cfg.home;
        OLLAYA_MODELS = cfg.modelsDir;
        OLLAYA_HOST = "${cfg.host}:${toString cfg.port}";
      };
      serviceConfig =
        lib.optionalAttrs staticUser {
          User = cfg.user;
          Group = cfg.group;
        }
        // {
          Type = "exec";
          DynamicUser = true;
          ExecStart = "${ollaya} serve";
          WorkingDirectory = cfg.home;
          StateDirectory = [ "ollaya" ];
          ReadWritePaths = [
            cfg.home
            cfg.modelsDir
          ];

          CapabilityBoundingSet = [ "" ];
          DeviceAllow = [
            "char-nvidiactl"
            "char-nvidia-caps"
            "char-nvidia-frontend"
            "char-nvidia-uvm"
            "char-drm"
            "char-fb"
            "char-kfd"
            "/dev/dxg"
          ];
          DevicePolicy = "closed";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = false;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "all";
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
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          SupplementaryGroups = [ "render" ];
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service @resources"
            "~@privileged"
          ];
          UMask = "0077";
        };
    };

    systemd.services.ollaya-model-loader = lib.mkIf (cfg.loadModels != [ ]) {
      description = "Download ollaya models in the background";
      wantedBy = [
        "multi-user.target"
        "ollaya.service"
      ];
      wants = [ "network-online.target" ];
      after = [
        "ollaya.service"
        "network-online.target"
      ];
      bindsTo = [ "ollaya.service" ];
      environment = config.systemd.services.ollaya.environment;
      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "1s";
        RestartMaxDelaySec = "2h";
        RestartSteps = "10";
      };
      script =
        let
          nproc = lib.getExe' pkgs.coreutils "nproc";
          xargs = lib.getExe' pkgs.findutils "xargs";
        in
        ''
          printf "%s\0" ${lib.escapeShellArgs cfg.loadModels} | '${xargs}' -0 -r -n 1 -P "$('${nproc}')" '${ollaya}' pull
        '';
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ happysalada ];
}
