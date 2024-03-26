import ../make-test-python.nix (
  { pkgs, lib, ... }: {
    name = "podman";
    meta = {
      maintainers = lib.teams.podman.members;
    };

    nodes = {
      rootful = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        # hack to ensure that podman built with and without zfs in extraPackages is cached
        boot.supportedFilesystems = [ "zfs" ];
        networking.hostId = "00000000";
      };
      rootless = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        users.users.alice = {
          isNormalUser = true;
        };
      };
      dns = { pkgs, ... }: {
        virtualisation.podman.enable = true;

        virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
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


      rootful.wait_for_unit("sockets.target")
      rootless.wait_for_unit("sockets.target")
      dns.wait_for_unit("sockets.target")
      docker.wait_for_unit("sockets.target")
      start_all()

      with subtest("Run container as root with runc"):
          rootful.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful.succeed(
              "podman run --runtime=runc -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          rootful.succeed("podman ps | grep sleeping")
          rootful.succeed("podman stop sleeping")
          rootful.succeed("podman rm sleeping")

      with subtest("Run container as root with crun"):
          rootful.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful.succeed(
              "podman run --runtime=crun -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          rootful.succeed("podman ps | grep sleeping")
          rootful.succeed("podman stop sleeping")
          rootful.succeed("podman rm sleeping")

      with subtest("Run container as root with the default backend"):
          rootful.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful.succeed(
              "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          rootful.succeed("podman ps | grep sleeping")
          rootful.succeed("podman stop sleeping")
          rootful.succeed("podman rm sleeping")

      # start systemd session for rootless
      rootless.succeed("loginctl enable-linger alice")
      rootless.succeed(su_cmd("whoami"))
      rootless.sleep(1)

      with subtest("Run container rootless with runc"):
          rootless.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          rootless.succeed(
              su_cmd(
                  "podman run --runtime=runc -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          rootless.succeed(su_cmd("podman ps | grep sleeping"))
          rootless.succeed(su_cmd("podman stop sleeping"))
          rootless.succeed(su_cmd("podman rm sleeping"))

      with subtest("Run container rootless with crun"):
          rootless.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          rootless.succeed(
              su_cmd(
                  "podman run --runtime=crun -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          rootless.succeed(su_cmd("podman ps | grep sleeping"))
          rootless.succeed(su_cmd("podman stop sleeping"))
          rootless.succeed(su_cmd("podman rm sleeping"))

      with subtest("Run container rootless with the default backend"):
          rootless.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          rootless.succeed(
              su_cmd(
                  "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
              )
          )
          rootless.succeed(su_cmd("podman ps | grep sleeping"))
          rootless.succeed(su_cmd("podman stop sleeping"))
          rootless.succeed(su_cmd("podman rm sleeping"))

      with subtest("rootlessport"):
          rootless.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          rootless.succeed(
              su_cmd(
                  "podman run -d -p 9000:8888 --name=rootlessport -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin -w ${pkgs.writeTextDir "index.html" "<h1>Testing</h1>"} scratchimg ${pkgs.python3}/bin/python -m http.server 8888"
              )
          )
          rootless.succeed(su_cmd("podman ps | grep rootlessport"))
          rootless.wait_until_succeeds(su_cmd("${pkgs.curl}/bin/curl localhost:9000 | grep Testing"))
          rootless.succeed(su_cmd("podman stop rootlessport"))
          rootless.succeed(su_cmd("podman rm rootlessport"))

      with subtest("Run container with init"):
          rootful.succeed(
              "tar cv -C ${pkgs.pkgsStatic.busybox} . | podman import - busybox"
          )
          pid = rootful.succeed("podman run --rm busybox readlink /proc/self").strip()
          assert pid == "1"
          pid = rootful.succeed("podman run --rm --init busybox readlink /proc/self").strip()
          assert pid == "2"

      with subtest("aardvark-dns"):
          dns.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          dns.succeed(
              "podman run -d --name=webserver -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin -w ${pkgs.writeTextDir "index.html" "<h1>Testing</h1>"} scratchimg ${pkgs.python3}/bin/python -m http.server 8000"
          )
          dns.succeed("podman ps | grep webserver")
          dns.wait_until_succeeds(
              "podman run --rm --name=client -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg ${pkgs.curl}/bin/curl http://webserver:8000 | grep Testing"
          )
          dns.succeed("podman stop webserver")
          dns.succeed("podman rm webserver")

      with subtest("A podman member can use the docker cli"):
          docker.succeed(su_cmd("docker version"))

      with subtest("Run container via docker cli"):
          docker.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          docker.succeed(
            "docker run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin localhost/scratchimg /bin/sleep 10"
          )
          docker.succeed("docker ps | grep sleeping")
          docker.succeed("podman ps | grep sleeping")
          docker.succeed("docker stop sleeping")
          docker.succeed("docker rm sleeping")

      with subtest("A podman non-member can not use the docker cli"):
          docker.fail(su_cmd("docker version", user="mallory"))

      # TODO: add docker-compose test

    '';
  }
)
