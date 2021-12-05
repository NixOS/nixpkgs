{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    optionalString
    types
    ;

  kernelPath = "${config.boot.kernelPackages.kernel}/" +
    "${config.system.boot.loader.kernelFile}";
  initrdPath = "${config.system.build.initialRamdisk}/" +
    "${config.system.boot.loader.initrdFile}";
in
{
  options = {
    system.boot.loader.id = mkOption {
      internal = true;
      default = "";
      description = ''
        Id string of the used bootloader.
      '';
    };

    system.boot.loader.kernelFile = mkOption {
      internal = true;
      default = pkgs.stdenv.hostPlatform.linux-kernel.target;
      defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.linux-kernel.target";
      type = types.str;
      description = ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };

    system.boot.loader.initrdFile = mkOption {
      internal = true;
      default = "initrd";
      type = types.str;
      description = ''
        Name of the initrd file to be passed to the bootloader.
      '';
    };
  };

  config = {
    # Containers don't have their own kernel or initrd.  They boot
    # directly into stage 2.
    system.systemBuilderCommands = mkIf (!config.boot.isContainer) ''
      if [ ! -f ${kernelPath} ]; then
        echo "The bootloader cannot find the proper kernel image."
        echo "(Expecting ${kernelPath})"
        false
      fi

      ln -s ${kernelPath} $out/kernel
      ln -s ${config.system.modulesTree} $out/kernel-modules
      ${optionalString (config.hardware.deviceTree.package != null) ''
        ln -s ${config.hardware.deviceTree.package} $out/dtbs
      ''}

      echo -n "$kernelParams" > $out/kernel-params

      ln -s ${initrdPath} $out/initrd

      ln -s ${config.system.build.initialRamdiskSecretAppender}/bin/append-initrd-secrets $out

      ln -s ${config.hardware.firmware}/lib/firmware $out/firmware

      echo -n "${config.boot.kernelPackages.stdenv.hostPlatform.system}" > $out/system
    '';
  };
}
