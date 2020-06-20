{ lib, pkgs, ... }:
{
  # This can be removed when the default kernel is at least version 5.6
  # https://github.com/NixOS/nixpkgs/pull/86168
  boot.kernelPackages = lib.mkIf
    (lib.versionOlder pkgs.linux.version "5.6")
    (lib.mkDefault pkgs.linuxPackages_5_6);

  # This can be removed when PulseAudio is at least version 14
  # https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_7)#Audio
  hardware.pulseaudio.extraConfig = ''
    load-module module-alsa-sink   device=hw:0,0 channels=4
    load-module module-alsa-source device=hw:0,6 channels=4
  '';
}
