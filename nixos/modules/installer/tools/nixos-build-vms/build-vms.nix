{ system ? builtins.currentSystem
, config ? {}
, networkExpr
}:

let
  nodes = builtins.mapAttrs (vm: module: {
    _file = "${networkExpr}@node-${vm}";
    imports = [
      module
      ({ pkgs, ... }: {
        virtualisation.qemu.package = pkgs.qemu;
      })
    ];
  }) (import networkExpr);
in

with import ../../../../lib/testing-python.nix {
  inherit system;
  pkgs = import ../../../../.. { inherit system config; };
};

(makeTest { inherit nodes; testScript = ""; }).driver
