import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "nspawn-imperative";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes =
    let
      base = { config, pkgs, ... }: {
        # Needed to make sure that the DHCPServer of `systemd-networkd' properly works and
        # can assign IPv4 addresses to containers.
        time.timeZone = "Europe/Berlin";
        networking.firewall.allowedUDPPorts = [ 53 67 68 546 547 ];
        environment.systemPackages = [ pkgs.nixos-nspawn pkgs.jq ];
        nix.nixPath = [ "nixpkgs=${../..}" ];
        nix.useSandbox = false;
        nix.binaryCaches = []; # don't try to access cache.nixos.org
        virtualisation.memorySize = 4096;
        virtualisation.writableStore = true;
        system.extraDependencies = [ pkgs.hello ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
          interfaces.eth0.useDHCP = true;
          interfaces.eth1.useDHCP = true;
        };

        # from containers-imperative.nix
        virtualisation.pathsInNixDB = let
          emptyContainer = import ../lib/eval-config.nix {
            inherit (config.nixpkgs.localSystem) system;
            modules = lib.singleton {
              containers.foo.config = { environment.systemPackages = [ pkgs.hello ]; };
            };
          };
        in with pkgs; [
          stdenv stdenvNoCC emptyContainer.config.containers.foo.path
          libxslt desktop-file-utils texinfo docbook5 libxml2
          docbook_xsl_ns xorg.lndir documentation-highlighter sudo-nspawn
          nginxStable coreutils gixy mailcap
        ];
      };
    in {
      imperative_and_declarative = { pkgs, ... }: {
        imports = [ base ];
        nixos.containers.instances.bar = {
          config.environment.systemPackages = [ pkgs.hello ];
          zone = "foo";
        };

        nixos.containers.zones = {
          foo.hostAddresses = [ "10.100.200.1/24" ];
        };
      };
      only_imperative = { pkgs, ... }: {
        imports = [ base ];
      };
    };

  testScript = let empty = pkgs.writeText "foo.nix" "{ config.nixpkgs = \"${../..}\"; }"; in ''
    start_all()

    def create_container(vm):
        print(vm.succeed(
          "nixos-nspawn create foo ${pkgs.writeText "foo.nix" ''
            {
              config.nixpkgs = "${../..}";
              config.config = { pkgs, ... }:
                { environment.systemPackages = [ pkgs.hello ]; };
            }
          ''}"
        ))

    only_imperative.wait_for_unit("multi-user.target")
    imperative_and_declarative.wait_for_unit("multi-user.target")
    imperative_and_declarative.wait_for_unit("machines.target")

    with subtest("Interactions with nixos-nspawn"):
        only_imperative.succeed("test -z \"$(nixos-nspawn list)\"")
        create_container(only_imperative)

        only_imperative.succeed("test 1 = \"$(nixos-nspawn list --json | jq 'length')\"")

        only_imperative.succeed("test 1 = \"$(nixos-nspawn list-generations foo | wc -l)\"")
        # `nixos-nspawn` must not throw an error if nothing is specified.
        only_imperative.succeed("nixos-nspawn")

        imperative_and_declarative.succeed("test -z \"$(nixos-nspawn list --imperative)\"")
        imperative_and_declarative.fail("nixos-nspawn list-generations bar")
        create_container(imperative_and_declarative)
        imperative_and_declarative.succeed("test 2 = \"$(nixos-nspawn list --json | jq 'length')\"")
        imperative_and_declarative.succeed("test 1 = \"$(nixos-nspawn list --imperative --json | jq 'length')\"")

    with subtest("Backtraces / error handling"):
        out = only_imperative.fail(
            "nixos-nspawn --show-trace create bar ${pkgs.writeText "bar.nix" ''
              {
                config.sharedNix = false;
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: {};
              }
            ''} 2>&1"
        )

        # expect python backtrace
        assert 'File "/run/current-system/sw/bin/nixos-nspawn"' in out
        # expect nix backtrace
        assert 'Output from nix-env: error: while evaluating' in out
        # expect actual error
        assert "Experimental `sharedNix'-feature isn't supported for imperative containers!" in out

        # Broken state will be left around for debugging purposes,
        # but must be cleaned up properly, when removing.
        only_imperative.fail(
            "nixos-nspawn --show-trace create bar ${empty}"
        )
        only_imperative.succeed("nixos-nspawn remove bar")
        only_imperative.succeed(
            "nixos-nspawn create bar ${empty}"
        )

    with subtest("Update / Rollback"):
        out = only_imperative.fail(
            "nixos-nspawn 2>&1 create bar23 ${pkgs.writeText "bar23.nix" ''
              {
                config.activation.strategy = "dynamic";
                config.nixpkgs = "${../..}";
              }
            ''}"
        )

        assert "`dynamic` is currently not supported!" in out
        only_imperative.succeed("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")
        out = only_imperative.succeed(
            "nixos-nspawn update 2>&1 foo --reload --config ${pkgs.writeText "foo2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: {};
              }
            ''}"
        )

        assert "Reloading container foo" in out

        only_imperative.fail(
            "systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'"
        )

        only_imperative.succeed("test 2 = \"$(nixos-nspawn list-generations foo | wc -l)\"")
        only_imperative.succeed("nixos-nspawn rollback foo --reload")

        only_imperative.wait_until_succeeds("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")

        # Existing container cannot be re-created
        only_imperative.fail(
            "nixos-nspawn create foo ${empty}"
        )

    with subtest("Networking"):
        # Container is in the host network-namespace by default, so no own IP.
        only_imperative.fail("ping -c4 foo")
        out = only_imperative.succeed(
            "nixos-nspawn create foonet ${pkgs.writeText "foo2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                config.network = {};
                config.forwardPorts = [ { hostPort = 8080; containerPort = 80; } ];
              }
            ''}"
        )

        assert "Warning: IPv6 SLAAC currently not supported for imperative containers!" in out

        # RFC1918 private IP assigned via DHCP
        only_imperative.wait_until_succeeds("ping -c4 foonet")

        only_imperative.succeed("curl --fail -i >&2 foonet:80")
        host_ip = only_imperative.succeed("ip --json a s ve-foonet | jq '.[].addr_info|.[]|select(.local|startswith(\"192.168\"))|.local' -r").strip()
        only_imperative.succeed(f"curl --fail -i >&2 {host_ip}:8080")

        only_imperative.succeed("test -e /etc/systemd/network/20-ve-foonet.network")

        # Proper cleanup
        only_imperative.succeed("nixos-nspawn remove foonet")
        only_imperative.wait_until_fails("ping -c4 foonet")
        only_imperative.fail("test -e /etc/systemd/network/20-ve-foonet.network")

        imperative_and_declarative.succeed(
            "nixos-nspawn create foozone ${pkgs.writeText "foo2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                config.network = {};
                config.zone = "foo";
              }
            ''}"
        )

        imperative_and_declarative.wait_until_succeeds("ip a s vb-foozone")
        imperative_and_declarative.fail("ip a s ve-foozone")

        # Don't start a container if zone does not exist
        imperative_and_declarative.fail(
            "nixos-nspawn create foozone2 ${pkgs.writeText "foo2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                config.network = {};
                config.zone = "foo2";
              }
            ''}"
        )

    with subtest("Removal"):
        only_imperative.succeed("nixos-nspawn remove foo")
        only_imperative.fail("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")
        only_imperative.fail("test -e /etc/systemd/nspawn/foo.nspawn")

    with subtest("Static networking"):
        only_imperative.succeed(
            "nixos-nspawn create foonet2 ${pkgs.writeText "foonet2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.network.v4.static = {
                  containerPool = [ "10.42.42.2/24" ];
                  hostAddresses = [
                    "10.42.42.1/24"
                  ];
                };
              }
            ''}"
        )

        only_imperative.wait_until_succeeds("ping >&2 -c4 10.42.42.2")
        only_imperative.succeed("machinectl status foonet2 | grep 10.42.42.2")

    with subtest("Reboot via machinectl(1)"):
        only_imperative.succeed("machinectl poweroff foonet2")
        only_imperative.wait_until_fails("ping >&2 -c4 10.42.42.2")
        only_imperative.succeed("machinectl start foonet2")
        only_imperative.wait_until_succeeds("ping >&2 -c4 10.42.42.2")

    only_imperative.shutdown()
    imperative_and_declarative.shutdown()
  '';
})
