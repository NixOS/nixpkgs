{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Set to true for just the first run, then disable it.
  # boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Load GPU drivers.
  # hardware.bumblebee.enable = lib.mkDefault true;

  # High DPI for X users. 175 "looks reasonable" but I didn't do the actual DPI
  # calculation.
  # services.xserver.dpi = lib.mkDefault 175;

  # Earlier font-size setup
  console.earlySetup = true;

  # Prevent small EFI partiion from filling up
  boot.loader.grub.configurationLimit = 10;

  # The 48.ucode causes the Killer wifi card to crash.
  # The iwlfwifi-cc-a0-46.ucode works perfectly
  nixpkgs.pkgs = import <nixpkgs> {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (old: {
          src = super.fetchgit{
            url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
            rev = "bf13a71b18af229b4c900b321ef1f8443028ded8";
            sha256 = "1dcaqdqyffxiadx420pg20157wqidz0c0ca5mrgyfxgrbh6a4mdj";
          };
          postInstall = ''
            rm $out/lib/firmware/iwlwifi-cc-a0-48.ucode
          '';
          outputHash = "0dq48i1cr8f0qx3nyq50l9w9915vhgpwmwiw3b4yhisbc3afyay4";
        });
      })
    ];
  };
}
