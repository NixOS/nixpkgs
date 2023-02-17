{ config, lib, utils, pkgs, ... }: let

  cfg = config.systemd.shutdownRamfs;

  shutdownRamfsContents = let
    storePaths = map (p: "${p}\n") cfg.storePaths;
    contents = lib.mapAttrsToList (_: v: "${v.source}\n${v.target}") (lib.filterAttrs (_: v: v.enable) cfg.contents);
  in lib.concatStringsSep "\n" (storePaths ++ contents);

  shutdownRamfs = pkgs.runCommand "shutdown-ramfs" {
    nativeBuildInputs = [ pkgs.makeInitrdNGTool ];
    passAsFile = [ "contents" ];
    contents = shutdownRamfsContents;
  } ''
    mkdir $out
    make-initrd-ng "$contentsPath" $out
  '';

in {
  options.systemd.shutdownRamfs = {
    enable = lib.mkEnableOption (lib.mdDoc "pivoting back to an initramfs for shutdown") // { default = true; };
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

    systemd.mounts = [{
      what = "tmpfs";
      where = "/run/initramfs";
      type = "tmpfs";
    }];

    systemd.services.load-shutdown-ramfs = {
      description = "Load shutdown ramfs";
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
        ExecStart = "${pkgs.coreutils}/bin/cp -Ta ${shutdownRamfs} /run/initramfs";
      };
    };
  };
}
