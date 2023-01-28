import ../make-test-python.nix (
  { pkgs, lib, ... }: {
    name = "podman";
    meta = {
      maintainers = lib.teams.podman.members;
    };

    nodes = {
      podman = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        users.users.alice = {
          isNormalUser = true;
        };
      };
      dns = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

        networking.firewall.allowedUDPPorts = [ 53 ];
      };
      docker = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        virtualisation.podman.dockerSocket.enable = true;

        environment.systemPackages = [
          pkgs.docker-client
        ];

        users.users.alice = {
          isNormalUser = true;
          extraGroups = [ "podman" ];
        };

        users.users.mallory = {
          isNormalUser = true;
        };
      };
    };

    testScript = ''
      import shlex


      def su_cmd(cmd, user = "alice"):
          cmd = shlex.quote(cmd)
          return f"su {user} -l -c {cmd}"


      podman.wait_for_unit("sockets.target")
      dns.wait_for_unit("sockets.target")
      docker.wait_for_unit("sockets.target")
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

      # start systemd session for rootless
      podman.succeed("loginctl enable-linger alice")
      podman.succeed(su_cmd("whoami"))
      podman.sleep(1)

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

      with subtest("aardvark-dns"):
        dns.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
        dns.succeed(
          "podman run -d --name=webserver -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin -w ${pkgs.writeTextDir "index.html" "<h1>Hi</h1>"} scratchimg ${pkgs.python3}/bin/python -m http.server 8000"
        )
        dns.succeed("podman ps | grep webserver")
        dns.succeed("""
          for i in `seq 0 120`; do
            podman run --rm --name=client -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg ${pkgs.curl}/bin/curl http://webserver:8000 >/dev/console \
              && exit 0
            sleep 0.5
          done
          exit 1
        """)
        dns.succeed("podman stop webserver")
        dns.succeed("podman rm webserver")

      with subtest("A podman member can use the docker cli"):
          docker.succeed(su_cmd("docker version"))

      with subtest("Run container via docker cli"):
          docker.succeed("docker network create default")
          docker.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          docker.succeed(
            "docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin localhost/scratchimg /bin/sleep 10"
          )
          docker.succeed("docker ps | grep sleeping")
          docker.succeed("podman ps | grep sleeping")
          docker.succeed("docker stop sleeping")
          docker.succeed("docker rm sleeping")
          docker.succeed("docker network rm default")

      with subtest("A podman non-member can not use the docker cli"):
          docker.fail(su_cmd("docker version", user="mallory"))

      # TODO: add docker-compose test

    '';
  }
)
