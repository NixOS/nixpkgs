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

  package = cfg.package.override (oldArgs: {
    extraPackages = ps: (oldArgs.extraPackages or (_: [ ]) ps) ++ cfg.extraPackages ps;
  });

  modelDrvs = map (m: {
    inherit m;
    drv = pkgs.fetchurl (lib.filterAttrs (n: _: n == "name" || n == "url" || n == "hash") m);
  }) cfg.models;

  modelSymlinks = lib.concatMapStringsSep "\n" (
    x:
    lib.concatMapStringsSep "\n" (p: ''
      mkdir -p ${lib.escapeShellArg "${cfg.dataDir}/models/${p}"}
      ln -sn ${lib.escapeShellArg "${x.drv}"} ${lib.escapeShellArg "${cfg.dataDir}/models/${p}/${x.m.name}"}
    '') x.m.installPaths
  ) modelDrvs;
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

      finalPackage = lib.mkOption {
        type = lib.types.package;
        internal = true;
        readOnly = true;
        default = package;
        description = "The final ComfyUI package which is being used in the service.";
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

      models = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = ''
                  The model file name, used as the link name in `models/<installPath>/<name>`.
                  It must be unique within the same `<installPath>`, to avoid conflicts.
                '';
              };
              url = lib.mkOption {
                type = lib.types.str;
                description = ''
                  The download URL of the model file.
                  Pinned-resolve URLs (e.g. HuggingFace's `/resolve/<commit>/<file>`) are recommended to have a stable hash.
                '';
              };
              hash = lib.mkOption {
                type = lib.types.str;
                example = lib.fakeHash;
                description = ''
                  The SRI hash of the model file. Generate it with `nix-prefetch-url <url>`,
                  or set this to `lib.fakeHash`, build once and copy the hash from the error message.
                '';
              };
              installPaths = lib.mkOption {
                # A directory string is converted to a list.
                type =
                  with lib.types;
                  coercedTo (strMatching "[A-Za-z0-9_-]+") lib.singleton (
                    nonEmptyListOf (strMatching "[A-Za-z0-9_-]+")
                  );
                description = ''
                  String or list of target subdirectory names below `models/`, such as `upscale_models`, `loras`, `checkpoints`.
                  Write bare directory names (the module assembles them into `models/<installPath>`,
                  one symlink per install path); a single string is also accepted and upgraded to a one-element list.
                '';
                example = [ "upscale_models" ];
              };
            };
          }
        );
        default = [ ];
        example = lib.literalExpression ''
          [ {
            name = "RealESRGAN_x4plus_anime_6B.pth";
            url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth";
            hash = "sha256-+HLYN9PJDtLgUie+1xGvVnGm/RyffX6RyRGmHxVemdo=";
            installPaths = "upscale_models";
          } ]
        '';
        description = ''
          ComfyUI models to fetch and symlink into `''${services.comfyui.dataDir}/models/<installPath>/<name>`.
          Files placed manually in the `models` directory are left untouched.
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        default = _: [ ];
        defaultText = lib.literalExpression "ps: with ps; [ ]";
        example = lib.literalExpression ''
          ps: with ps; [ comfyui-manager ]
        '';
        description = ''
          List of packages to add to ComfyUI's Python environment.

          A popular example is `python3Packages.comfyui-manager` for installing and
          managing custom nodes from within ComfyUI.
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
            cp --no-preserve=all -r ${cfg.finalPackage}/share/comfyui/$d "${cfg.dataDir}/"
          fi
        done

        # Remove all symlinks pointing into /nix/store, then relink them, so that no stale ones are left behind.
        readarray -d "" stale < <(find "${cfg.dataDir}/models" -type l -print0)
        for link in "''${stale[@]}"; do
          if [[ "$(readlink "$link")" == ${lib.escapeShellArg builtins.storeDir}/* ]]; then
            rm "$link"
          fi
        done

        # Rebuild model symlinks
        ${modelSymlinks}
      '';

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.finalPackage} ${lib.escapeShellArgs cfg.extraArgs}";
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
