{ config, pkgs, modulesPath, ... }:

{
  require = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
}
