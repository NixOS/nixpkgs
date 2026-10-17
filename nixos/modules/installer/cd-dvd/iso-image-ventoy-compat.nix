{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.isoImage.ventoyCompatProtocol = lib.mkEnableOption "the Ventoy Compatible protocol" // {
    default = true;
    example = false;
  };

  config = lib.mkIf config.isoImage.ventoyCompatProtocol {
    isoImage.contents = [
      {
        source = pkgs.writeText "ventoy.dat" "";
        target = "/ventoy.dat";
      }
    ];

    boot.initrd.availableKernelModules = [
      "efivarfs"
      "exfat"
    ];

    boot.initrd.systemd = {
      packages = [ pkgs.ventoy-compat-protocol ];
      extraBin.ventoy-compat-protocol = "${pkgs.ventoy-compat-protocol}/bin/ventoy-compat-protocol";
      contents."/etc/systemd/system-generators/ventoy-compat-protocol-generator".source =
        "${pkgs.ventoy-compat-protocol}/bin/ventoy-compat-protocol-generator";
    };

    boot.initrd.services.udev.packages = lib.mkIf config.boot.initrd.systemd.enable [
      pkgs.ventoy-compat-protocol
    ];

    boot.initrd.extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      cp ${pkgs.ventoy-compat-protocol}/lib/udev/rules.d/70-ventoy.rules $out/
      substituteInPlace "$out/70-ventoy.rules" \
        --replace ${pkgs.ventoy-compat-protocol}/bin/ventoy-compat-protocol \
        ${config.system.build.extraUtils}/bin/ventoy-compat-protocol
    '';
    boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.ventoy-compat-protocol}/bin/ventoy-compat-protocol
      copy_bin_and_libs ${pkgs.util-linux}/bin/losetup
    '';
    boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      ventoy-compat-protocol detect-hook || fail

      if [ -e /sys/firmware/efi ]; then
        mkdir -p /sys/firmware/efi/efivars
        mount -t efivarfs efivarfs /sys/firmware/efi/efivars
      fi

      if iso_path="$(ventoy-compat-protocol print-iso-path)"; then
        waitDevice /dev/ventoy
        mkdir /run/ventoy
        mount -t "$(ventoy-compat-protocol print-file-system)" /dev/ventoy /run/ventoy || fail
        losetup -P -f /run/ventoy"$iso_path" || fail
      fi
    '';
  };
}
