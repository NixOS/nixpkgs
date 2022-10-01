# This test runs podman and checks AppArmor default confinement

import ../make-test-python.nix (
  { pkgs, lib, ... }: {
    name = "podman-apparmor";
    meta = with lib; {
      maintainers = teams.podman.members + (with maintainers; [amarshall]);
    };

    nodes = {
      podman =
        { pkgs, ... }: {
          virtualisation.podman.enable = true;
          security.apparmor.enable = true;

          users.users.alice = {
            isNormalUser = true;
            home = "/home/alice";
            description = "Alice Foobar";
            extraGroups = [ "podman" ];
          };
        };
    };

    testScript = ''
      import shlex


      def su_cmd(cmd, user = "alice"):
          cmd = shlex.quote(cmd)
          return f"su {user} -l -c {cmd}"


      with subtest("Run container as root"):
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
              "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("podman inspect sleeping -f '{{.AppArmorProfile}}' | grep -v unconfined | grep -E '^.+$'")
          podman.succeed("podman stop sleeping")
          podman.succeed("podman rm sleeping")


      # create systemd session for rootless
      podman.succeed("loginctl enable-linger alice")


      with subtest("Run container rootless"):
          podman.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          podman.succeed(
              su_cmd(
                  "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          # AppArmor not supported rootless, but container should run
          podman.succeed(su_cmd("podman inspect sleeping -f '{{.AppArmorProfile}}' | grep -E '^$'"))
          podman.succeed(su_cmd("podman ps | grep sleeping"))
          podman.succeed(su_cmd("podman stop sleeping"))
          podman.succeed(su_cmd("podman rm sleeping"))
    '';
  }
)
