import ../make-test-python.nix ({ pkgs, lib, ... }: {
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
        nix.nixPath = [ "nixpkgs=${../../..}" ];
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
          emptyContainer = import ../../lib/eval-config.nix {
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
      imperativeanddeclarative = { pkgs, ... }: {
        imports = [ base ];
        nixos.containers.instances.bar = {
          system-config.environment.systemPackages = [ pkgs.hello ];
          zone = "foo";
        };

        nixos.containers.zones = {
          foo.hostAddresses = [ "10.100.200.1/24" ];
        };
      };
      onlyimperative = { pkgs, ... }: {
        imports = [ base ];
      };
    };

  testScript = let empty = pkgs.writeText "foo.nix" "{ nixpkgs = \"${../../..}\"; }"; in ''
    start_all()

    def create_container(vm):
        print(vm.succeed(
          "nixos-nspawn create foo ${pkgs.writeText "foo.nix" ''
            {
              nixpkgs = "${../../..}";
              system-config = { pkgs, ... }:
                { environment.systemPackages = [ pkgs.hello ]; };
            }
          ''}"
        ))

    onlyimperative.wait_for_unit("multi-user.target")
    imperativeanddeclarative.wait_for_unit("multi-user.target")
    imperativeanddeclarative.wait_for_unit("machines.target")

    with subtest("Interactions with nixos-nspawn"):
        onlyimperative.succeed("test -z \"$(nixos-nspawn list)\"")
        create_container(onlyimperative)

        onlyimperative.succeed("test 1 = \"$(nixos-nspawn list --json | jq 'length')\"")

        onlyimperative.succeed("test 1 = \"$(nixos-nspawn list-generations foo | wc -l)\"")
        # `nixos-nspawn` must not throw an error if nothing is specified.
        onlyimperative.succeed("nixos-nspawn")

        imperativeanddeclarative.succeed("test -z \"$(nixos-nspawn list --imperative)\"")
        imperativeanddeclarative.fail("nixos-nspawn list-generations bar")
        create_container(imperativeanddeclarative)
        imperativeanddeclarative.succeed("test 2 = \"$(nixos-nspawn list --json | jq 'length')\"")
        imperativeanddeclarative.succeed("test 1 = \"$(nixos-nspawn list --imperative --json | jq 'length')\"")

    with subtest("Backtraces / error handling"):
        out = onlyimperative.fail(
            "nixos-nspawn --show-trace create bar ${pkgs.writeText "bar.nix" ''
              {
                sharedNix = false;
                nixpkgs = "${../../..}";
                system-config = { pkgs, ... }: {};
              }
            ''} 2>&1"
        )

        # expect python backtrace
        assert 'File "/run/current-system/sw/bin/nixos-nspawn"' in out
        # expect nix backtrace
        assert 'Output from nix-env:        … while calling anonymous lambda' in out
        # expect actual error
        assert "Experimental `sharedNix'-feature isn't supported for imperative containers!" in out

        # Broken state will be left around for debugging purposes,
        # but must be cleaned up properly, when removing.
        onlyimperative.fail(
            "nixos-nspawn --show-trace create bar ${empty}"
        )
        onlyimperative.succeed("nixos-nspawn remove bar")
        onlyimperative.succeed(
            "nixos-nspawn create bar ${empty}"
        )

    with subtest("Update / Rollback"):
        out = onlyimperative.fail(
            "nixos-nspawn 2>&1 create bar23 ${pkgs.writeText "bar23.nix" ''
              {
                activation.strategy = "dynamic";
                nixpkgs = "${../../..}";
              }
            ''}"
        )

        assert "`dynamic` is currently not supported!" in out
        onlyimperative.succeed("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")
        out = onlyimperative.succeed(
            "nixos-nspawn update 2>&1 foo --reload --config ${pkgs.writeText "foo2.nix" ''
              {
                nixpkgs = "${../../..}";
                system-config = { pkgs, ... }: {};
              }
            ''}"
        )

        assert "Reloading container foo" in out

        onlyimperative.fail(
            "systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'"
        )

        onlyimperative.succeed("test 2 = \"$(nixos-nspawn list-generations foo | wc -l)\"")
        onlyimperative.succeed("nixos-nspawn rollback foo --reload")

        onlyimperative.succeed("systemd-run -M foo --pty /bin/sh --login -c 'hello'")

        # Existing container cannot be re-created
        onlyimperative.fail(
            "nixos-nspawn create foo ${empty}"
        )

    with subtest("Networking"):
        # Container is in the host network-namespace by default, so no own IP.
        # FIXME find out if this has changed and what we should do here.
        #onlyimperative.fail("ping -c4 foo >&2")
        out = onlyimperative.succeed(
            "nixos-nspawn create foonet ${pkgs.writeText "foo2.nix" ''
              {
                nixpkgs = "${../../..}";
                system-config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                network = {};
              }
            ''}"
        )

        assert "Warning: IPv6 SLAAC currently not supported for imperative containers!" in out

        # RFC1918 private IP assigned via DHCP
        onlyimperative.wait_until_succeeds("ping -c4 foonet")

        onlyimperative.succeed("curl --fail -i >&2 foonet:80")

        onlyimperative.succeed("test -e /etc/systemd/network/20-ve-foonet.network")

        # Proper cleanup
        onlyimperative.succeed("nixos-nspawn remove foonet")
        onlyimperative.wait_until_fails("ping -c4 foonet")
        onlyimperative.fail("test -e /etc/systemd/network/20-ve-foonet.network")

        imperativeanddeclarative.succeed(
            "nixos-nspawn create foozone ${pkgs.writeText "foo2.nix" ''
              {
                nixpkgs = "${../../..}";
                system-config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                network = {};
                zone = "foo";
              }
            ''}"
        )

        imperativeanddeclarative.wait_until_succeeds("ip a s vb-foozone")
        imperativeanddeclarative.fail("ip a s ve-foozone")

        # Don't start a container if zone does not exist
        imperativeanddeclarative.fail(
            "nixos-nspawn create foozone2 ${pkgs.writeText "foo2.nix" ''
              {
                nixpkgs = "${../../..}";
                system-config = { pkgs, ... }: { services.nginx.enable = true; networking.firewall.allowedTCPPorts = [ 80 ]; };
                network = {};
                zone = "foo2";
              }
            ''}"
        )

    with subtest("Removal"):
        onlyimperative.succeed("nixos-nspawn remove foo")
        onlyimperative.fail("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")
        onlyimperative.fail("test -e /etc/systemd/nspawn/foo.nspawn")

    with subtest("Static networking"):
        onlyimperative.succeed(
            "nixos-nspawn create foonet2 ${pkgs.writeText "foonet2.nix" ''
              {
                nixpkgs = "${../../..}";
                network.v4.static = {
                  containerPool = [ "10.42.42.2/24" ];
                  hostAddresses = [
                    "10.42.42.1/24"
                  ];
                };
              }
            ''}"
        )

        onlyimperative.wait_until_succeeds("ping >&2 -c4 10.42.42.2")
        onlyimperative.succeed("machinectl status foonet2 | grep 10.42.42.2")

    with subtest("Reboot via machinectl(1)"):
        onlyimperative.succeed("machinectl poweroff foonet2")
        onlyimperative.wait_until_fails("ping >&2 -c4 10.42.42.2")
        onlyimperative.succeed("machinectl start foonet2")
        onlyimperative.wait_until_succeeds("ping >&2 -c4 10.42.42.2")

    onlyimperative.shutdown()
    imperativeanddeclarative.shutdown()
  '';
})
