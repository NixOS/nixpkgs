{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.bcachefs-unlock.enable =
    lib.mkEnableOption "unlocking bcachefs file systems with a systemd generator."
    // {
      default =
        (config.boot.supportedFilesystems.bcachefs or false)
        || (config.boot.initrd.supportedFilesystems.bcachefs or false);
      defaultText = "boot.supportedFilesystems.bcachefs || boot.initrd.supportedFilesystems.bcachefs";
    };

  config = lib.mkIf config.bcachefs-unlock.enable {
    boot.initrd.systemd.contents."/etc/systemd/system-generators/bcachefs-fstab-generator".source =
      "${pkgs.bcachefs-fstab-generator}/bin/bcachefs-fstab-generator";

    boot.initrd.systemd.services."bcachefs-unlock@" = {
      overrideStrategy = "asDropin";
      path = [
        pkgs.bcachefs-tools
        config.boot.initrd.systemd.package
      ];
      serviceConfig.ExecSearchPath = lib.makeBinPath [ pkgs.bcachefs-tools ];
    };

    systemd.generators.bcachefs-fstab-generator = "${pkgs.bcachefs-fstab-generator}/bin/bcachefs-fstab-generator";

    systemd.services."bcachefs-unlock@" = {
      overrideStrategy = "asDropin";
      path = [
        pkgs.bcachefs-tools
        config.systemd.package
      ];
      serviceConfig.ExecSearchPath = lib.makeBinPath [ pkgs.bcachefs-tools ];
    };
  };
}
