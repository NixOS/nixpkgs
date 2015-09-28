{pkgs, config, ...}:

let
  wis_go7007 = config.boot.kernelPackages.wis_go7007;
in

{
  boot.extraModulePackages = [ wis_go7007 ];

  environment.systemPackages = [ wis_go7007 ];

  hardware.firmware = [ wis_go7007 ];

  services.udev.packages = [ wis_go7007 ];
}
