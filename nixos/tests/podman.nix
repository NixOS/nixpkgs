# This test runs podman and checks if simple container starts

import ./make-test-python.nix (
  { pkgs, lib, ... }: {
    name = "podman";
    meta = {
      maintainers = lib.teams.podman.members;
    };

    nodes = {
      podman =
        { pkgs, ... }:
          {
            virtualisation.podman.enable = true;
          };
    };

    testScript = ''
      start_all()

      podman.wait_for_unit("sockets.target")
      podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
      podman.succeed(
          "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
      )
      podman.succeed("podman ps | grep sleeping")
      podman.succeed("podman stop sleeping")
    '';
  }
)
