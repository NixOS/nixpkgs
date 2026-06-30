import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    quadletContainerFile = pkgs.writeText "quadlet.container" ''
      [Unit]
      Description=A test quadlet container

      [Container]
      Image=localhost/scratchimg:latest
      Exec=bash -c 'trap exit SIGTERM SIGINT; while true; do sleep 1; done'
      ContainerName=quadlet
      Volume=/nix/store:/nix/store
      Volume=/run/current-system/sw/bin:/bin

      [Install]
      WantedBy=default.target
    '';
  in
  {
    name = "podman";
    meta = {
      maintainers = lib.teams.podman.members;
    };

    nodes = {
      rootful =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;

          # hack to ensure that podman built with and without zfs in extraPackages is cached
          boot.supportedFilesystems = [ "zfs" ];
          networking.hostId = "00000000";
        };
      rootful_norunc =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;
          virtualisation.podman.extraRuntimes = [ ];
        };
      rootless =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;

          users.users.alice = {
            isNormalUser = true;
          };
        };
      dns =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;

          virtualisation.podman.defaultNetwork.settings.dns_enabled = true;
        };
      docker =
        { pkgs, ... }:
        {
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

      # Asserts that `firewall.trustBridge = true` lets a container reach a
      # host service whose port is allow-listed only on the host's primary
      # interface (not on the bridge). With `false` the same connection is
      # dropped by the host firewall.
      trustBridge =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;
          virtualisation.podman.firewall.trustBridge = true;

          # Per-interface allow-list: 12345 open on eth0, NOT on podman0
          # (and not in the global allow-list). Without trustBridge=true,
          # container-originated traffic to the host on this port is dropped.
          networking.firewall.allowedTCPPorts = [ ];
          networking.firewall.interfaces.eth0.allowedTCPPorts = [ 12345 ];

          # Tiny host service bound to all interfaces; reachable only
          # through the firewall hole on whichever interface the request
          # arrives on.
          systemd.services.host-probe = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig.ExecStart = "${pkgs.python3}/bin/python -m http.server --bind 0.0.0.0 12345";
          };
        };

      noTrustBridge =
        { pkgs, ... }:
        {
          virtualisation.podman.enable = true;
          virtualisation.podman.firewall.trustBridge = false;

          networking.firewall.allowedTCPPorts = [ ];
          networking.firewall.interfaces.eth0.allowedTCPPorts = [ 12345 ];

          systemd.services.host-probe = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig.ExecStart = "${pkgs.python3}/bin/python -m http.server --bind 0.0.0.0 12345";
          };
        };
    };

    testScript = ''
      import shlex


      def su_cmd(cmd, user = "alice"):
          cmd = shlex.quote(cmd)
          return f"su {user} -l -c {cmd}"


      rootful.wait_for_unit("sockets.target")
      rootful_norunc.wait_for_unit("sockets.target")
      rootless.wait_for_unit("sockets.target")
      dns.wait_for_unit("sockets.target")
      docker.wait_for_unit("sockets.target")
      trustBridge.wait_for_unit("sockets.target")
      noTrustBridge.wait_for_unit("sockets.target")
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

      # now without installed runc
      with subtest("Run runc-less container as root with runc"):
          rootful_norunc.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful_norunc.fail(
              "podman run --runtime=runc -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )

      with subtest("Run runc-less container as root with crun"):
          rootful_norunc.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful_norunc.succeed(
              "podman run --runtime=crun -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          rootful_norunc.succeed("podman ps | grep sleeping")
          rootful_norunc.succeed("podman stop sleeping")
          rootful_norunc.succeed("podman rm sleeping")

      with subtest("Run runc-less container as root with the default backend"):
          rootful_norunc.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          rootful_norunc.succeed(
              "podman run -d --name=sleeping -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg /bin/sleep 10"
          )
          rootful_norunc.succeed("podman ps | grep sleeping")
          rootful_norunc.succeed("podman stop sleeping")
          rootful_norunc.succeed("podman rm sleeping")

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

      with subtest("A rootless quadlet container service is created"):
          dir = "/home/alice/.config/containers/systemd"
          rootless.succeed(su_cmd("tar cv --files-from /dev/null | podman import - scratchimg"))
          rootless.succeed(su_cmd(f"mkdir -p {dir}"))
          rootless.succeed(su_cmd(f"cp -f ${quadletContainerFile} {dir}/quadlet.container"))
          rootless.systemctl("daemon-reload", "alice")
          rootless.systemctl("start network-online.target")
          rootless.systemctl("start quadlet", "alice")
          rootless.wait_until_succeeds(su_cmd("podman ps | grep quadlet"), timeout=20)
          rootless.systemctl("stop quadlet", "alice")

      with subtest("firewall.trustBridge=true allows container -> host on per-iface allow-listed port"):
          trustBridge.wait_for_unit("host-probe.service")
          trustBridge.wait_for_open_port(12345)

          host_ip = trustBridge.succeed("ip -o -4 addr show eth0 | awk '{print $4}' | cut -d/ -f1").strip()

          trustBridge.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          # The default network puts the container on podman0; without
          # trustBridge=true, the host's firewall would drop the SYN since
          # 12345 is allow-listed only on eth0.
          trustBridge.succeed(
              "podman run --rm -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg "
              f"${pkgs.curl}/bin/curl --max-time 5 --silent --fail http://{host_ip}:12345/"
          )

      with subtest("firewall.trustBridge=false (default) blocks the same connection"):
          noTrustBridge.wait_for_unit("host-probe.service")
          noTrustBridge.wait_for_open_port(12345)

          host_ip = noTrustBridge.succeed("ip -o -4 addr show eth0 | awk '{print $4}' | cut -d/ -f1").strip()

          noTrustBridge.succeed("tar cv --files-from /dev/null | podman import - scratchimg")
          # Container's curl should fail with timeout/refused. We assert curl exits non-zero.
          noTrustBridge.fail(
              f"podman run --rm -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg "
              f"${pkgs.curl}/bin/curl --max-time 5 --silent --fail http://{host_ip}:12345/"
          )

      # TODO: add docker-compose test

    '';
  }
)
