/* imported from https://nixos.org/wiki/Acer_4810T */

{ config, pkgs, lib, ... }:

{
 # Make te network WLAN card (wlan0) firmware available
 require = [ <nixpkgs>/nixos/modules/hardware/network/intel-5000.nix ];

 boot = rec {
   initrd.kernelModules = [ "ata_piix" ];
   kernelParams = [
      "apm=on"
      "acpi=on"
      "vga=0x317"   
      "video=vesafb:ywrap"
      # Important, to disable Kernel Mode Setting for the graphics card
      # This will allow backlight regulation
      "nomodeset"
   ];
   kernelModules = [
     "kvm-intel"
   ];
 };

 services = {
   xserver = {
     enable = true;
     defaultDepth = 24;
     videoDriver = "intel";
     autorun = true;
     driSupport = false;
     synaptics = {
       enable = true;
       dev = "/dev/input/event8";
     };
  };
};
