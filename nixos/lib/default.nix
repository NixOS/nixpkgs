let
  # module system
  modules = import ./modules.nix;
  options = import ./options.nix;
  types = import ./types.nix;

  # nixpkgs lib
  nixpkgs = import ../../lib;
in
{

  inherit modules options types;

  eval-config = import ./eval-config.nix;
  build-vms = import ./build-vms.nix;
  from-env = import ./from-env.nix; 
  utils = import ./utils.nix;

} // modules // options // types // nixpkgs
