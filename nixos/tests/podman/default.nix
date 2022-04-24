# This test runs podman and checks if simple container starts

import ../make-test-python.nix (
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

          # To test docker socket support
          virtualisation.podman.dockerSocket.enable = true;
          environment.systemPackages = [
            pkgs.docker-client
          ];

          users.users.alice = {
            isNormalUser = true;
            home = "/home/alice";
            description = "Alice Foobar";
            extraGroups = [ "podman" ];
          };

          users.users.mallory = {
            isNormalUser = true;
            home = "/home/mallory";
            description = "Mallory Foobar";
          };

        };
    };

    testScript = ''
      import shlex


      def su_cmd(cmd, user = "alice"):
          cmd = shlex.quote(cmd)
          return f"su {user} -l -c {cmd}"


      podman.wait_for_unit("sockets.target")
      start_all()

      with subtest("Run container as root with runc"):
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
              "podman run --runtime=runc -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("podman stop sleeping")
          podman.succeed("podman rm sleeping")

      with subtest("Run container as root with crun"):
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
              "podman run --runtime=crun -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("podman stop sleeping")
          podman.succeed("podman rm sleeping")

      with subtest("Run container as root with the default backend"):
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
              "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("podman stop sleeping")
          podman.succeed("podman rm sleeping")

      # create systemd session for rootless
      podman.succeed("loginctl enable-linger alice")

      with subtest("Run container rootless with runc"):
          podman.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          podman.succeed(
              su_cmd(
                  "podman run --runtime=runc -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          podman.succeed(su_cmd("podman ps | grep sleeping"))
          podman.succeed(su_cmd("podman stop sleeping"))
          podman.succeed(su_cmd("podman rm sleeping"))

      with subtest("Run container rootless with crun"):
          podman.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          podman.succeed(
              su_cmd(
                  "podman run --runtime=crun -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          podman.succeed(su_cmd("podman ps | grep sleeping"))
          podman.succeed(su_cmd("podman stop sleeping"))
          podman.succeed(su_cmd("podman rm sleeping"))

      with subtest("Run container rootless with the default backend"):
          podman.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          podman.succeed(
              su_cmd(
                  "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          podman.succeed(su_cmd("podman ps | grep sleeping"))
          podman.succeed(su_cmd("podman stop sleeping"))
          podman.succeed(su_cmd("podman rm sleeping"))

      with subtest("Run container with init"):
          podman.succeed(
              "tar cv -C ${pkgs.pkgsStatic.busybox} . | podman import - busybox"
          )
          pid = podman.succeed("podman run --rm busybox readlink /proc/self").strip()
          assert pid == "1"
          pid = podman.succeed("podman run --rm --init busybox readlink /proc/self").strip()
          assert pid == "2"

      with subtest("A podman member can use the docker cli"):
          podman.succeed(su_cmd("docker version"))

      with subtest("Run container via docker cli"):
          podman.succeed("docker network create default")
          podman.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          podman.succeed(
            "docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin localhost/scratchimg /bin/sleep 10"
          )
          podman.succeed("docker ps | grep sleeping")
          podman.succeed("podman ps | grep sleeping")
          podman.succeed("docker stop sleeping")
          podman.succeed("docker rm sleeping")
          podman.succeed("docker network rm default")

      with subtest("A podman non-member can not use the docker cli"):
          podman.fail(su_cmd("docker version", user="mallory"))

      # TODO: add docker-compose test

    '';
  }
)
