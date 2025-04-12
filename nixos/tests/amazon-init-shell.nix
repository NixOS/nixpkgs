# This test verifies that the amazon-init service can treat the `user-data` ec2
# metadata file as a shell script. If amazon-init detects that `user-data` is a
# script (based on the presence of the shebang #! line) it executes it and
# exits.
# Note that other tests verify that amazon-init can treat user-data as a nixos
# configuration expression.

{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

makeTest {
  name = "amazon-init";
  meta = with maintainers; {
    maintainers = [ urbas ];
  };
  nodes.machine =
    { lib, pkgs, ... }:
    {
      imports = [
        ../modules/profiles/headless.nix
        ../modules/virtualisation/amazon-init.nix
      ];
      services.openssh.enable = true;
      system.switch.enable = true;
      networking.hostName = "";
      environment.etc."ec2-metadata/user-data" = {
        text = ''
          #!/usr/bin/bash

          echo successful > /tmp/evidence

          # Emulate running nixos-rebuild switch, just without any building.
          # https://github.com/nixos/nixpkgs/blob/4c62505847d88f16df11eff3c81bf9a453a4979e/nixos/modules/virtualisation/amazon-init.nix#L55
          /run/current-system/bin/switch-to-configuration test
        '';
      };
    };
  testScript = ''
    # To wait until amazon-init terminates its run
    unnamed.wait_for_unit("amazon-init.service")

    unnamed.succeed("grep -q successful /tmp/evidence")
  '';
}
