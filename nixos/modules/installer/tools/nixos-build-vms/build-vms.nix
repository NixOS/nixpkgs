{ system ? builtins.currentSystem
, config ? {}
, networkExpr
}:

let
  nodes = builtins.mapAttrs (vm: module: {
    _file = "${networkExpr}@node-${vm}";
    imports = [ module ];
  }) (import networkExpr);

  testing = import ../../../../lib/testing-python.nix {
    inherit system;
    pkgs = import ../../../../.. { inherit system config; };
  };

  interactiveDriver = (testing.makeTest { inherit nodes; testScript = "start_all(); join_all();"; }).driverInteractive;
in


pkgs.runCommand "nixos-build-vms" ''
  mkdir -p $out/bin
  ln -s ${interactiveDriver}/bin/nixos-test-driver $out/bin/nixos-test-driver
  ln -s ${interactiveDriver}/bin/nixos-test-driver $out/bin/nixos-run-vms
  wrapProgram $out/bin/nixos-test-driver \
    --add-flags "--interactive"
''
