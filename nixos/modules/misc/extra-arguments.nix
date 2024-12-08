{ lib, config, pkgs, ... }:

{
  _module.args = {
    utils = import ../../lib/utils.nix { inherit lib config pkgs; };
  };
}
