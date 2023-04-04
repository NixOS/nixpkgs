import ../make-test-python.nix ({ pkgs, lib, ... }: let
  instances.dynamic = {
    activation.strategy = "dynamic";
    network.v4.static = {
      containerPool = [ "10.231.136.2/24" ];
      hostAddresses = [ "10.231.136.1/24" ];
    };
  };

  instances.teststop = {
    network.v4.static = {
      containerPool = [ "10.231.137.2/24" ];
      hostAddresses = [ "10.231.137.1/24" ];
    };
  };

  instances.restart = {
    activation.strategy = "restart";
    network.v4.static = {
      containerPool = [ "10.231.138.2/24" ];
      hostAddresses = [ "10.231.138.1/24" ];
    };
  };

  instances.reload = {
    activation.strategy = "reload";
    network.v4.static = {
      containerPool = [ "10.231.139.2/24" ];
      hostAddresses = [ "10.231.139.1/24" ];
    };
  };

  instances.none = {
    activation.strategy = "none";
    network.v4.static = {
      containerPool = [ "10.231.140.2/24" ];
      hostAddresses = [ "10.231.140.1/24" ];
    };
  };

  instances.dynamic2 = {
    activation.strategy = "dynamic";
    network.v4.static = {
      containerPool = [ "10.231.141.2/24" ];
      hostAddresses = [ "10.231.141.1/24" ];
    };
  };

  instances.static = {
    activation.strategy = "dynamic";
    zone = "foo";
    network = {
      v4 = {
        static.containerPool = [ "10.231.142.2/24" ];
        addrPool = lib.mkForce [];
      };
      v6.addrPool = lib.mkForce [];
    };
  };
in {
  name = "container-tests";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes = {
    machine = { ... }: {
      networking = {
        useDHCP = false;
        useNetworkd = true;
        interfaces.eth0.useDHCP = true;
      };

      nixos.containers = {
        instances = lib.mkDefault instances;
        zones.foo = {
          hostAddresses = [ "10.231.142.1/24" ];
          v4.addrPool = [];
          v6.addrPool = [];
        };
      };

      specialisation = rec {
        configchange.configuration = { lib, pkgs, ... }: {
          nixos.containers.instances = lib.mkMerge [
            (lib.filterAttrs (name: lib.const (name != "teststop")) instances)
            {
              dynamic.system-config = {
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
            }
            {
              dynamic2.system-config = {
                services.nginx.enable = true;
              };
            }
          ];

          systemd.nspawn.restart.filesConfig.BindReadOnly = [ "/etc:/foo" ];
          systemd.nspawn.reload.filesConfig.BindReadOnly = [ "/etc:/foo" ];
        };
        configchange2.configuration = { lib, pkgs, ... }: {
          imports = [ configchange.configuration ];
          systemd.nspawn.dynamic.filesConfig.BindReadOnly = [ "/etc:/foo" ];
          nixos.containers.instances = {
            new = {
              network.v4.static.containerPool = [ "10.231.150.2/24" ];
              network.v4.static.hostAddresses = [ "10.231.150.1/24" ];
            };
            restart = {
              network.v4.static.containerPool = [ "10.231.151.2/24" ];
              network.v4.static.hostAddresses = [ "10.231.151.1/24" ];
            };
          };
        };
      };
    };
  };

  testScript = { nodes, ... }: let
    switchTo = sp: "${nodes.machine.config.system.build.toplevel}/specialisation/${sp}/bin/switch-to-configuration test";
  in ''
    from typing import Dict, List
    machine.start()
    machine.wait_for_unit("network.target")
    machine.wait_for_unit("machines.target")

    with subtest("Initial state"):
        available = machine.succeed("machinectl")
        for i in ['dynamic', 'teststop', 'restart', 'reload']:
            assert i in available, f"Expected machine {i} in `machinectl output!"

        for j in range(136, 143):
            machine.wait_until_succeeds(f"ping -c3 10.231.{str(j)}.2 >&2")

        machine.fail("curl 10.231.136.2 -sSf --connect-timeout 10")

        machine.succeed("systemd-run -M static --pty --quiet -- /bin/sh --login -c 'networkctl | grep host0 | grep configured'")

        for m in ['reload', 'restart']:
            machine.fail(
                f"systemd-run -M {m} --pty --quiet -- /bin/sh --login -c 'test -e /foo/systemd'"
            )

    with subtest("Activate changes"):
        machine.succeed("machinectl stop dynamic2")
        act_output = machine.succeed(
            "${switchTo "configchange"} 2>&1 | tee /dev/stderr"
        ).split('\n')
        machine.succeed("sleep 10")

        units: Dict[str, List[str]] = {}
        for state in ['stopping', 'starting', 'restarting', 'reloading']:
            units[state] = []
            outline = f"{state} the following units: "
            for line in act_output:
                if line.startswith(outline):
                    units[state] = line.replace(outline, "").split(', ')
                    break

        print(units)
        assert "systemd-nspawn@reload.service" in units['reloading']
        assert "systemd-nspawn@reload.service" not in units['restarting']

        assert "systemd-nspawn@dynamic2.service" not in units['reloading']
        assert "systemd-nspawn@dynamic2.service" not in units['restarting']

        assert "systemd-nspawn@restart.service" in units['restarting']
        assert "systemd-nspawn@restart.service" not in units['reloading']

        assert "systemd-nspawn@dynamic.service" in units['reloading']
        assert "systemd-nspawn@dynamic.service" not in units['restarting']

        assert "systemd-nspawn@reload.service" not in units['starting']
        assert "systemd-nspawn@restart.service" not in units['starting']
        assert "systemd-nspawn@teststop.service" in units['stopping']
        assert "systemd-nspawn@none.service" not in act_output

    with subtest("Check for successful activation"):
        machine.wait_until_succeeds("curl 10.231.136.2 -sSf --connect-timeout 10")
        machine.fail("ping -c3 10.231.137.2 -c3")

        machine.wait_until_succeeds("ping -c3 10.231.138.2 >&2")
        machine.succeed(
            "systemd-run -M restart --pty --quiet -- /bin/sh --login -c 'test -e /foo/systemd'"
        )

        # A reload is forced for this machine, but a reload doesn't refresh bind mounts.
        machine.fail(
            "systemd-run -M reload --pty --quiet -- /bin/sh --login -c 'test -e /foo/systemd'"
        )

    with subtest("More changes"):
        machine.succeed(
            "${switchTo "configchange2"} 2>&1 | tee /dev/stderr"
        )

        machine.wait_until_succeeds("ping -c3 10.231.136.2 >&2")

        machine.succeed(
            "systemd-run -M dynamic --pty --quiet -- /bin/sh --login -c 'test -e /foo/systemd'"
        )

        machine.wait_until_succeeds("ping -c3 10.231.150.2 >&2")

    machine.shutdown()
  '';
})
