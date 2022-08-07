{ config, lib, utils, pkgs, ... }: let

  cfg = config.systemd.shutdownRamfs;

  ramfsContents = let
    storePaths = map (p: "${p}\n") cfg.storePaths;
    contents = lib.mapAttrsToList (_: v: "${v.source}\n${v.target}") (lib.filterAttrs (_: v: v.enable) cfg.contents);
  in pkgs.writeText "shutdown-ramfs-contents" (lib.concatStringsSep "\n" (storePaths ++ contents));

in {
  options.systemd.shutdownRamfs = {
    enable = lib.mkEnableOption "pivoting back to an initramfs for shutdown" // { default = true; };
    contents = lib.mkOption {
      description = lib.mdDoc "Set of files that have to be linked into the shutdown ramfs";
      example = lib.literalExpression ''
        {
          "/lib/systemd/system-shutdown/zpool-sync-shutdown".source = writeShellScript "zpool" "exec ''${zfs}/bin/zpool sync"
        }
      '';
      type = utils.systemdUtils.types.initrdContents;
    };

    storePaths = lib.mkOption {
      description = lib.mdDoc ''
        Store paths to copy into the shutdown ramfs as well.
      '';
      type = lib.types.listOf lib.types.singleLineStr;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.shutdownRamfs.contents."/shutdown".source = "${config.systemd.package}/lib/systemd/systemd-shutdown";
    systemd.shutdownRamfs.storePaths = [pkgs.runtimeShell "${pkgs.coreutils}/bin"];

    systemd.services.generate-shutdown-ramfs = {
      description = "Generate shutdown ramfs";
      wantedBy = [ "shutdown.target" ];
      before = [ "shutdown.target" ];
      unitConfig = {
        DefaultDependencies = false;
        ConditionFileIsExecutable = [
          "!/run/initramfs/shutdown"
        ];
      };

      path = [pkgs.util-linux pkgs.makeInitrdNGTool];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /run/initramfs
        if ! mountpoint -q /run/initramfs; then
          mount -t tmpfs tmpfs /run/initramfs
        fi
        make-initrd-ng ${ramfsContents} /run/initramfs
      '';
    };
  };
}
