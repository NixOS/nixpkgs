{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.qemu.firmware;
in

{
  options.virtualisation.qemu.firmware = {
    enable = lib.mkEnableOption "QEMU firmware descriptors in {file}`/etc/qemu/firmware`";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.qemu ];
      defaultText = lib.literalExpression "[ pkgs.qemu ]";
      example = lib.literalExpression "[ pkgs.qemu pkgs.OVMF-amdsev.fd ]";
      description = ''
        Packages providing QEMU firmware descriptors under
        {file}`share/qemu/firmware`, following the QEMU firmware interop
        convention (see {file}`docs/interop/firmware.json` in the QEMU
        source tree). The descriptors are merged and linked to
        {file}`/etc/qemu/firmware`, where tools like
        {command}`systemd-vmspawn` discover the firmware available for
        running virtual machines.

        The default exposes the descriptors of the firmware images
        bundled with QEMU. Note that setting this option replaces the
        default, so include `pkgs.qemu` when adding further firmware.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."qemu/firmware".source =
      let
        merged = pkgs.buildEnv {
          name = "qemu-firmware-descriptors";
          paths = cfg.packages;
          pathsToLink = [ "/share/qemu/firmware" ];
        };
      in
      "${merged}/share/qemu/firmware";
  };

  meta.maintainers = [ lib.maintainers.katexochen ];
}
