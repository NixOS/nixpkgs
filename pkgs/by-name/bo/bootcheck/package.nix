{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bootcheck";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "notzorua";
    repo = "bootcheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-avBjw3qGdiD9lVFXp2sJayHTplDtLDdalmsHqSC6d0E=";
  };

  vendorHash = null;

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Check whether a NixOS machine will boot before rebooting it";
    longDescription = ''
      Verifies that the kernels referenced by the GRUB menu exist on the EFI
      system partition, that the bootloader entry is still present and first in
      the UEFI boot order, that the menu boots the system that was actually
      built, that the partition has room left, and that no files are left behind
      by bootloaders no longer in use.
    '';
    homepage = "https://github.com/notzorua/bootcheck";
    changelog = "https://github.com/notzorua/bootcheck/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ notzorua ];
    mainProgram = "bootcheck";
    platforms = lib.platforms.linux;
  };
})
