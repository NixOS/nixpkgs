{ lib, pkgs, ... }:
{
  name = "secureBoot";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  meta.platforms = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  nodes.machine =
    { lib, pkgs, ... }:
    let
      # An unsigned EFI binary, signed by the bootloader installer below.
      unsignedEfi = "${pkgs.limine}/share/limine/BOOT${lib.toUpper pkgs.stdenv.hostPlatform.efiArch}.EFI";
      notAnEfiBinary = pkgs.writeText "not-an-efi-binary" "definitely not a PE file";
    in
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      virtualisation.efi.keepVariables = true;

      boot.loader.efi.canTouchEfiVariables = true;

      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.limine.secureBoot.enable = true;
      boot.loader.limine.secureBoot.autoGenerateKeys = true;
      boot.loader.limine.secureBoot.autoEnrollKeys.enable = true;
      boot.loader.limine.secureBoot.autoEnrollKeys.extraArgs = [ "--yes-this-might-brick-my-machine" ];
      boot.loader.timeout = 0;

      boot.loader.limine.additionalFiles = {
        # signed automatically, it is a PE/COFF image
        "efi/additional/unsigned.efi" = unsignedEfi;
        # left alone automatically, it is not a PE/COFF image
        "efi/additional/not-an-efi-binary" = notAnEfiBinary;
        # left alone explicitly, even though it could be signed
        "efi/additional/explicitly-skipped.efi" = unsignedEfi;
      };
      boot.loader.limine.secureBoot.signAdditionalFiles.skip = [
        "efi/additional/explicitly-skipped.efi"
      ];

      services.fwupd.enable = true;

      environment.systemPackages = [
        pkgs.mokutil
        pkgs.sbctl
      ];
    };

  testScript =
    let
      signed = "/boot/efi/additional/unsigned.efi";
      notSignable = "/boot/efi/additional/not-an-efi-binary";
      explicitlySkipped = "/boot/efi/additional/explicitly-skipped.efi";
      unsignedEfi = pkgs.limine + "/share/limine/BOOT${lib.toUpper pkgs.stdenv.hostPlatform.efiArch}.EFI";
    in
    ''
      machine.start()
      assert "SecureBoot enabled" in machine.succeed("mokutil --sb-state")

      # fwupd is D-Bus activated, so the signing unit only runs on demand.
      machine.succeed("systemctl start fwupd.service")
      machine.wait_for_unit("fwupd-efi.service")
      # the unsigned app is copied in by the fwupd module, the signed one added here
      machine.succeed("ls /run/fwupd-efi/fwupd*.efi")
      machine.succeed("ls /run/fwupd-efi/fwupd*.efi.signed")

      # a PE/COFF image is signed automatically
      assert '"is_signed": 1' in machine.succeed("sbctl verify --json ${signed}")

      # a file which is not a PE/COFF image is left alone instead of failing,
      # and is still copied over verbatim
      assert machine.succeed("cat ${notSignable}").strip() == "definitely not a PE file"

      # a PE/COFF image in the skip list is left alone, so it stays byte for
      # byte identical to the source it was copied from
      machine.succeed("cmp ${explicitlySkipped} ${unsignedEfi}")
    '';
}
