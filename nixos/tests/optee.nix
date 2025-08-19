import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "optee";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ jmbaur ];
    };

    nodes.machine =
      { config, pkgs, ... }:
      let
        inherit (pkgs) armTrustedFirmwareQemu opteeQemuAarch64 ubootQemuAarch64;

        # Default environment for qemu-arm64 uboot does not work well with
        # large nixos kernel/initrds.
        uboot = ubootQemuAarch64.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace board/emulation/qemu-arm/qemu-arm.env \
              --replace-fail "ramdisk_addr_r=0x44000000" "ramdisk_addr_r=0x46000000"
          '';
        });

        bios = armTrustedFirmwareQemu.override {
          extraMakeFlags = [
            "SPD=opteed"
            "BL32=${opteeQemuAarch64}/tee-header_v2.bin"
            "BL32_EXTRA1=${opteeQemuAarch64}/tee-pager_v2.bin"
            "BL32_EXTRA2=${opteeQemuAarch64}/tee-pageable_v2.bin"
            "BL33=${uboot}/u-boot.bin"
            "all"
            "fip"
          ];
          filesToInstall = [
            "build/qemu/release/bl1.bin"
            "build/qemu/release/fip.bin"
          ];
          postInstall = ''
            dd if=$out/bl1.bin of=$out/bios.bin bs=4096 conv=notrunc
            dd if=$out/fip.bin of=$out/bios.bin seek=64 bs=4096 conv=notrunc
          '';
        };
      in
      {
        virtualisation = {
          inherit bios;
          cores = 2;
          qemu.options = [
            "-machine virt,secure=on,accel=tcg,gic-version=2"
            "-cpu cortex-a57"
          ];
        };

        # VM boots up via qfw
        boot.loader.grub.enable = false;

        services.tee-supplicant = {
          enable = true;
          # pkcs11 trusted application
          trustedApplications = [ "${opteeQemuAarch64.devkit}/ta/fd02c9da-306c-48c7-a49c-bbd827ae86ee.ta" ];
        };
      };
    testScript = ''
      machine.wait_for_unit("tee-supplicant.service")
      out = machine.succeed("${pkgs.opensc}/bin/pkcs11-tool --module ${lib.getLib pkgs.optee-client}/lib/libckteec.so --list-token-slots")
      if out.find("OP-TEE PKCS11 TA") < 0:
          raise Exception("optee pkcs11 token not found")
    '';
  }
)
