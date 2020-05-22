# Test for nixpkgs overlays inside NixOS containers.

import ./make-test-python.nix ({ pkgs, lib, ...} : let

  customHello = pkgs.hello.overrideAttrs(old: {
    name = "custom-hello";
  });

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
        config = {pkgs, config, ... }: {
          nixpkgs.overlays = [(self: super: {
            hello = customHello;
          })];

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
        "test $(nixos-container run simple -- readlink -f /run/current-system/sw/bin/hello) = ${customHello}/bin/hello"
    )
  '';
})
