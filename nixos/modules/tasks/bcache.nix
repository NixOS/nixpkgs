{ pkgs, ... }:

{

  environment.systemPackages = [ pkgs.bcache-tools ];

  services.udev.packages = [ pkgs.bcache-tools ];

  boot.initrd.extraUdevRulesCommands = ''
    cp -v ${pkgs.bcache-tools}/lib/udev/rules.d/*.rules $out/
  '';

}
