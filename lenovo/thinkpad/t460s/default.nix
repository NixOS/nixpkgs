{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../lib/kernel-version.nix
  ];

  # Use the gummiboot efi boot loader. (From default generated configuration.nix)
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T460s
  kernelAtleast = [
    { version = "4.5.1"; msg = "The physical mouse buttons works incorrectly."; }
    { version = "4.6";   msg = "Suspending the T460s by closing the lid when running on battery causes the machine to freeze up entirely."; }
  ];

  # For the screen. I don't know what to do with this information, but
  # the hiDPI support is far from perfect (as of July 2016):

  # Resolution: 2560 x 1440 px
  # Size: 12.2" × 6.86" (30.99cm × 17.43cm)
  # DPI: 209.8
  # Dot Pitch: 0.1211mm
  # Aspect Ratio: 16 × 9 (1.78:1)
  # Pixel Count: 3,686,400
  # Megapixels: 3.69MP

  services.xserver.videoDrivers = [ "intel" ];
}
