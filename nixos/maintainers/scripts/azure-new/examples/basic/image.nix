let
  # NOTE Messing with this import  will likely result in "The
  #      option  `virtualisation.azureImage`  defined in  ...
  #      does not exist.".
  #      See https://github.com/NixOS/nixpkgs/issues/86005
  pkgs = (import ../../../../../../default.nix {});
  machine = import "${pkgs.path}/nixos/lib/eval-config.nix" {
    # pkgs = import <nixpkgs> {};
    system = "x86_64-linux";
    modules = [
      ({config, ...}: { imports = [ ./system.nix ]; })
    ];
  };
in
  machine.config.system.build.azureImage
