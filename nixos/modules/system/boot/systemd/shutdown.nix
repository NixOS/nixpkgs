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
  };

  config = lib.mkIf cfg.enable {
    systemd.shutdownRamfs.contents = {
      "/shutdown".source = "${config.systemd.package}/lib/systemd/systemd-shutdown";
      "/etc/initrd-release".source = config.environment.etc.os-release.source;
      "/etc/os-release".source = config.environment.etc.os-release.source;
    };
    systemd.shutdownRamfs.storePaths = [
      pkgs.runtimeShell
      "${pkgs.coreutils}/bin"
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
        ProtectSystem = "strict";
        ReadWritePaths = "/run/initramfs";
        ExecStart = "${pkgs.makeInitrdNGTool}/bin/make-initrd-ng ${ramfsContents} /run/initramfs";
      };
    };
  };
}
