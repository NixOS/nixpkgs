# set of utilities for using contracts.
# templates of individual contracts are stored in `./templates`.
{ lib, ... }:
let
  callLibs = file: import file { inherit lib; };
in
{
  module = ./module.nix;
  definitionType = callLibs ./definition-type.nix;
}
// callLibs ./helpers.nix
