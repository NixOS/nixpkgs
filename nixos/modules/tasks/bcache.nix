{ config, pkgs, ... }:

{

  environment.systemPackages = [ pkgs.bcache-tools ];

  boot.initrd.extraUdevRulesCommands = ''
    cp -v ${pkgs.bcache-tools}/lib/udev/rules.d/*.rules $out/
  ''; 

}
