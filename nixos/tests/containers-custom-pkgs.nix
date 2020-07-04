# Test for NixOS' container support.

import ./make-test-python.nix ({ pkgs, lib, ...} : let

  customPkgs = pkgs // {
    hello = pkgs.hello.overrideAttrs(old: {
      name = "custom-hello";
    });
  };

in {
  name = "containers-hosts";
  meta = with lib.maintainers; {
    maintainers = [ adisbladis ];
  };

  machine =
    { ... }:
    {
      virtualisation.memorySize = 256;
      virtualisation.vlans = [];

      containers.simple = {
        autoStart = true;
        pkgs = customPkgs;
        config = {pkgs, config, ... }: {
          environment.systemPackages = [
            pkgs.hello
          ];
        };
      };

    };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")
    machine.succeed(
        "test $(nixos-container run simple -- readlink -f /run/current-system/sw/bin/hello) = ${customPkgs.hello}/bin/hello"
    )
  '';
})
