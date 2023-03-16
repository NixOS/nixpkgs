let
  pkgs = (import ../../../../../../default.nix {});
  machine = (import (pkgs.path + "/nixos/lib") {}).evalSystemConfiguration {
    modules = [
      { nixpkgs.system = "x86_64-linux"; }
      ({config, ...}: { imports = [ ./system.nix ]; })
    ];
  };
in
  machine.config.system.build.azureImage
