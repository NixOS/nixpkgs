{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.comfyui;

  # By default a StateDirectory is used; anything else needs its own directory and a hole in the unit's mount namespace.
  isDefaultDataDir = cfg.dataDir == "/var/lib/comfyui";
in
{
  options = {
    services.comfyui = {
      enable = lib.mkEnableOption "ComfyUI";
      package = lib.mkPackageOption pkgs "comfyui" { };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/comfyui";
        example = "/srv/comfyui";
        description = ''
          Directory holding ComfyUI's state: models, custom nodes, inputs, outputs and the database.

          Defaults to the unit's `StateDirectory`.
          Any other directory is created with systemd-tmpfiles and bind-mounted into the service.

          Existing state is not migrated, you need to move it yourself.
        '';
      };

      listen = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "127.0.0.1"
          "::1"
        ];
        example = [
          "0.0.0.0"
          "::"
        ];
        description = ''
          The host addresses on which ComfyUI should listen.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8188;
        example = 1234;
        description = ''
          The port on that ComfyUI will listen.
        '';
      };

      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        example = [
          "--enable-assets"
          "--preview-method=auto"
        ];
        description = ''
          Extra arguments to pass to the server. See `comfyui --help` for available args.

          Flags set by the module are prepended with `lib.mkBefore`, so any user supplied flag wins over that.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.comfyui.extraArgs = lib.mkBefore [
      "--base-directory=${cfg.dataDir}"
      "--database-url=sqlite:///${cfg.dataDir}/user/comfyui.db"
      "--listen=${lib.concatStringsSep "," cfg.listen}"
      "--port=${toString cfg.port}"
    ];

    # owner read back from the unit, not spelled out: StateDirectory= infers it, this rule has to be told
    systemd.tmpfiles.settings = lib.mkIf (!isDefaultDataDir) {
      "10-comfyui".${cfg.dataDir}.d = {
        user = config.systemd.services.comfyui.serviceConfig.User;
        group = config.systemd.services.comfyui.serviceConfig.Group;
        mode = "0700";
      };
    };

    systemd.services.comfyui = {
      description = "Powerful and modular diffusion model GUI, api and backend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        for d in custom_nodes input output models; do
          if [[ ! -d "${cfg.dataDir}/$d" ]]; then
            cp --no-preserve=all -r ${cfg.package}/share/comfyui/$d "${cfg.dataDir}/"
          fi
        done
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}";
        Group = "comfyui";
        Restart = "always";
        RestartSec = "5sec"; # don't crash loop immediately
        StateDirectory = lib.mkIf isDefaultDataDir "comfyui";
        Type = "simple";
        User = "comfyui";

        # This is a bind mount, not ReadWritePaths, so that with ProtectHome it is not shadowed by a tmpfs.
        BindPaths = lib.mkIf (!isDefaultDataDir) [ cfg.dataDir ];

        # required for Torch and GPU acceleration
        BindReadOnlyPaths = [ "/proc/cpuinfo" ];
        PrivateDevices = false;
        ProcSubset = "all";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = null;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "tmpfs";
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
        RuntimeDirectoryMode = "700";
        StateDirectoryMode = "700";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
      };
    };

    users = {
      groups.comfyui = { };
      users.comfyui = {
        group = "comfyui";
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = pkgs.comfyui.meta.maintainers;
}
