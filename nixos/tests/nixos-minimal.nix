{
  pkgs ? import ../.. { },
}:
let
  # aka `lib.nixos` in the nixpkgs flake
  nixosLib = import (pkgs.path + "/nixos/lib/default.nix") { };
  conf = nixosLib.evalModules {
    modules = [
      ../modules/minimal.nix
      {
        fileSystems."/".device = "/dev/null";
        boot.loader.grub.enable = false;
        nixpkgs.pkgs = pkgs;
      }
    ];
  };
in

conf.config.system.build.toplevel
