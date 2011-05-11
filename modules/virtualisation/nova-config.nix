{ config, pkgs, modulesPath, ... }:

{
  require = [ "${modulesPath}/virtualisation/nova-image.nix" ];
}
