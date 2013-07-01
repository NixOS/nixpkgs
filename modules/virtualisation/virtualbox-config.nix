{ config, pkgs, modulesPath, ... }:

{
  require = [ "${modulesPath}/virtualisation/virtualbox-image.nix" ];
}
