{
  config,
  lib,
  utils,
  pkgs,
  ...
}:
let

  cfg = config.systemd.shutdownRamfs;

  ramfsContents = pkgs.writeText "shutdown-ramfs-contents.json" (builtins.toJSON cfg.storePaths);

in
{
  options.systemd.shutdownRamfs = {
    enable = lib.mkEnableOption "pivoting back to an initramfs for shutdown" // {
      default = true;
    };

    contents = lib.mkOption {
      description = "Set of files that have to be linked into the shutdown ramfs";
      example = lib.literalExpression ''
        {
          "/lib/systemd/system-shutdown/zpool-sync-shutdown".source = writeShellScript "zpool" "exec ''${zfs}/bin/zpool sync"
        }
      '';
      type = utils.systemdUtils.types.initrdContents;
    };

    storePaths = lib.mkOption {
      description = ''
        Store paths to copy into the shutdown ramfs as well.
      '';
      type = utils.systemdUtils.types.initrdStorePath;
      default = [ ];
    };

    shell.enable = lib.mkEnableOption "" // {
      default = config.environment.shell.enable;
      internal = true;
      description = ''
        Whether to enable a shell in the shutdown ramfs.

        In contrast to `environment.shell.enable`, this option actually
        strictly disables all shells in the shutdown ramfs because they're not
        copied into it anymore. Paths that use a shell (e.g. via the `script`
        option), will break if this option is set.

        Only set this option if you're sure that you can recover from potential
        issues.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.shutdownRamfs.contents = {
      "/shutdown".source = "${config.systemd.package}/lib/systemd/systemd-shutdown";
      "/etc/initrd-release".source = config.environment.etc.os-release.source;
      "/etc/os-release".source = config.environment.etc.os-release.source;
    };
    systemd.shutdownRamfs.storePaths = [
      "${pkgs.coreutils}/bin"
    ]
    ++ lib.optionals cfg.shell.enable [
      pkgs.runtimeShell
    ]
    ++ map (c: builtins.removeAttrs c [ "text" ]) (builtins.attrValues cfg.contents);

    systemd.mounts = [
      {
        what = "tmpfs";
        where = "/run/initramfs";
        type = "tmpfs";
        options = "mode=0700";
      }
    ];

    systemd.services.generate-shutdown-ramfs = {
      description = "Generate shutdown ramfs";
      wantedBy = [ "shutdown.target" ];
      before = [ "shutdown.target" ];
      unitConfig = {
        DefaultDependencies = false;
        RequiresMountsFor = "/run/initramfs";
        ConditionFileIsExecutable = [
          "!/run/initramfs/shutdown"
        ];
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.makeInitrdNGTool}/bin/make-initrd-ng ${ramfsContents} /run/initramfs";

        # Sandboxing
        ProtectSystem = "strict";
        ReadWritePaths = "/run/initramfs";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        PrivateNetwork = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
      };
    };
  };
}
