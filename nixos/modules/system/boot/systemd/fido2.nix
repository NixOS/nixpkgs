{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.boot.initrd.systemd;
in
{
  options = {
    boot.initrd.systemd.fido2.enable = lib.mkEnableOption "systemd FIDO2 support" // {
      default = cfg.package.withFido2;
      defaultText = lib.literalExpression "config.boot.initrd.systemd.package.withFido2";
    };
  };

  config = lib.mkIf cfg.fido2.enable {
    boot.initrd.services.udev.packages = [
      # TODO: Add a better way to include upstream rules files.
      (pkgs.runCommand "udev-fido2" { } ''
        mkdir -p $out/lib/udev/rules.d/
        cp ${cfg.package}/lib/udev/rules.d/60-fido-id.rules $out/lib/udev/rules.d/60-fido-id.rules
      '')
    ];
    boot.initrd.systemd.storePaths = [
      "${pkgs.systemd}/lib/udev/fido_id"
      "${cfg.package}/lib/cryptsetup/libcryptsetup-token-systemd-fido2.so"
      "${pkgs.libfido2}/lib/libfido2.so.1"
    ];
  };
}
