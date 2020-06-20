{ config, lib, pkgs, ... }:

{
  boot = {
    extraModprobeConfig = lib.mkDefault ''
      options g_ether use_eem=0 dev_addr=1a:55:89:a2:69:41 host_addr=1a:55:89:a2:69:42
    '';

    kernelModules = [ "ledtrig_heartbeat" "ci_hdrc_imx" "g_ether" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_usbarmory;
    kernelParams =  [ "console=ttymxc0,115200" ];

    loader.generic-extlinux-compatible.enable = lib.mkDefault true;
  };

  networking = {
    defaultGateway = "172.16.0.1";
    firewall.enable = lib.mkDefault false;
    hostName = "usbarmory";

    interfaces.usb0.ip4 = [
      { address = "172.16.0.2"; prefixLength = 24; }
    ];

    nameservers = [ "8.8.8.8" ];
  };

  nix = {
    binaryCaches = [ "http://nixos-arm.dezgeg.me/channel" ];
    binaryCachePublicKeys = [ "nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%" ];
  };

  nixpkgs.overlays = [(final: previous: {
    linuxPackages_usbarmory = final.recurseIntoAttrs
      (final.linuxPackagesFor (import ./kernel.nix {
        inherit (final) stdenv buildLinux fetchurl;
      }));
  })];

  sound.enable = lib.mkDefault false;

  services = {
    openssh.enable = lib.mkDefault true;
    openssh.permitRootLogin = lib.mkDefault "without-password";
  };
}
