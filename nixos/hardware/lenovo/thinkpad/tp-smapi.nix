# tp_smapi works on ThinkPads made before 2013. See compat table:
# https://www.thinkwiki.org/wiki/Tp_smapi#Model-specific_status

{ config, ... }:

{
  boot = {
    kernelModules = [ "tp_smapi" ];
    extraModulePackages = with config.boot.kernelPackages; [ tp_smapi ];
  };
}
