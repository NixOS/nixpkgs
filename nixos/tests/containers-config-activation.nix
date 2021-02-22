import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "container-tests";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    base = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
        interfaces.eth0.useDHCP = true;
      };
      nixos.containers.instances.test = {
        network.v4.static.containerPool = [ "10.231.136.2/24" ];
        network.v4.static.hostAddresses = [ "10.231.136.1/24" ];
        activation.strategy = "reload";
      };
      nixos.containers.instances.test2 = {
        sharedNix = false;
        network.v4.static.containerPool = [ "10.231.137.2/24" ];
        network.v4.static.hostAddresses = [ "10.231.137.1/24" ];
        activation.strategy = "restart";
      };
    };
    configchange = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
        interfaces.eth0.useDHCP = true;
      };
      nixos.containers.instances.test = {
        network.v4.static.containerPool = [ "10.231.136.2/24" ];
        network.v4.static.hostAddresses = [ "10.231.136.1/24" ];
        activation.strategy = "reload";
        config = {
          services.nginx = {
            enable = true;
            virtualHosts."localhost" = {
              listen = [
                { addr = "10.231.136.2"; port = 80; ssl = false; }
              ];
            };
          };
          networking.firewall.allowedTCPPorts = [ 80 ];
        };
      };
      nixos.containers.instances.test2 = {
        sharedNix = false;
        network.v4.static.containerPool = [ "10.231.137.2/24" ];
        network.v4.static.hostAddresses = [ "10.231.137.1/24" ];
        activation.strategy = "restart";
        config = { pkgs, ... }: {
          environment.systemPackages = with pkgs; [ hello ];
        };
      };
    };
  };

  testScript = { nodes, ... }: let
    change = nodes.configchange.config.system.build.toplevel;
  in ''
    base.start()
    base.wait_for_unit("network.target")
    assert "test" in base.succeed("machinectl")
    base.wait_until_succeeds("ping -c3 10.231.136.1 >&2")
    base.wait_until_succeeds("ping -c3 10.231.136.2 >&2")
    base.wait_until_succeeds("ping -c3 10.231.137.2 >&2")

    base.fail("curl 10.231.136.2 -sSf --connect-timeout 10")

    out = base.succeed(
        "${change}/bin/switch-to-configuration test 2>&1 | tee /dev/stderr"
    )

    assert "reloading the following units: systemd-nspawn@test.service" in out
    assert (
        "restarting the following units: systemd-nspawn@test.service, systemd-nspawn@test2.service"
        not in out
    )

    base.wait_until_succeeds("ping -c3 10.231.136.2 >&2")
    base.wait_until_succeeds("ping -c3 10.231.137.2 >&2")
    base.execute("curl 10.231.136.2 -sSf --connect-timeout 10 | grep 'Welcome to nginx'")

    base.succeed("systemd-run -M test2 --pty --quiet -- /bin/sh --login -c 'hello'")

    base.execute("machinectl poweroff test")
    base.execute("machinectl poweroff test2")
    base.sleep(3)

    base.shutdown()
  '';
})
