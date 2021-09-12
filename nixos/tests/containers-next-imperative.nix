import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "nspawn-imperative";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes =
    let
      base = { config, pkgs, ... }: {
        environment.systemPackages = [ pkgs.nixos-nspawn pkgs.jq ];
        nix.nixPath = [ "nixpkgs=${../..}" ];
        nix.useSandbox = false;
        nix.binaryCaches = []; # don't try to access cache.nixos.org
        virtualisation.memorySize = 4096;
        virtualisation.writableStore = true;
        system.extraDependencies = [ pkgs.hello ];

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
          docbook_xsl_ns xorg.lndir documentation-highlighter
        ];
      };
    in {
      imperative_and_declarative = { pkgs, ... }: {
        imports = [ base ];
        nixos.containers.instances.bar = {
          config.environment.systemPackages = [ pkgs.hello ];
        };
      };
      only_imperative = { pkgs, ... }: {
        imports = [ base ];
      };
    };

  testScript = ''
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

    with subtest("Update / Rollback"):
        only_imperative.succeed("systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'")
        only_imperative.succeed(
            "nixos-nspawn update foo --config ${pkgs.writeText "foo2.nix" ''
              {
                config.nixpkgs = "${../..}";
                config.config = { pkgs, ... }: {};
              }
            ''}"
        )

        profile_actual = only_imperative.succeed(
            "readlink -f /nix/var/nix/profiles/per-nspawn/foo/system/bin/switch-to-configuration"
        ).strip()

        only_imperative.succeed(
            f"nsenter -t $(machinectl show foo --property Leader --value) -m -u -U -i -n -p -- {profile_actual} test"
        )

        only_imperative.fail(
            "systemd-run -M foo --pty --quiet /bin/sh --login -c 'hello'"
        )

    only_imperative.shutdown()
    imperative_and_declarative.shutdown()
  '';
})
