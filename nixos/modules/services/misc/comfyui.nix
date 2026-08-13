{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.comfyui;
in
{
  options = {
    services.comfyui = {
      enable = lib.mkEnableOption "ComfyUI";
      package = lib.mkPackageOption pkgs "comfyui" { };

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
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.comfyui.extraArgs = [
      "--base-directory=/var/lib/comfyui"
      "--database-url=sqlite:////var/lib/comfyui/user/comfyui.db"
      "--listen=${lib.concatStringsSep "," cfg.listen}"
      "--port=${toString cfg.port}"
    ];

    systemd.services.comfyui = {
      description = "Powerful and modular diffusion model GUI, api and backend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        for d in custom_nodes input output models; do
          if [[ ! -d /var/lib/comfyui/$d ]]; then
            cp --no-preserve=all -r ${cfg.package}/share/comfyui/$d /var/lib/comfyui/
          fi
        done
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}";
        Group = "comfyui";
        Restart = "always";
        RestartSec = "5sec"; # don't crash loop immediately
        StateDirectory = "comfyui";
        Type = "simple";
        User = "comfyui";

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
        home = "/var/lib/comfyui";
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = pkgs.comfyui.meta.maintainers;
}
