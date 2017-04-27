{ lib, pkgs, config, ... }:

{
  _module.args = {
    utils = import ../../lib/utils.nix pkgs;
  };
}
