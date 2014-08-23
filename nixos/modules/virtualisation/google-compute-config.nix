{ config, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/google-compute-image.nix" ];
}
