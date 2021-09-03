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
      };
      only_imperative = { pkgs, ... }: {
        imports = [ base ];
      };
    };

  testScript = ''
    start_all()

    only_imperative.wait_for_unit("multi-user.target")
    imperative_and_declarative.wait_for_unit("multi-user.target")
    imperative_and_declarative.wait_for_unit("machines.target")

    only_imperative.succeed("test -z \"$(nixos-nspawn list)\"")
    print(only_imperative.succeed(
      "nixos-nspawn create foo ${pkgs.writeText "foo.nix" ''
        {
          config.nixpkgs = "${../..}";
          config.config = { pkgs, ... }:
            { environment.systemPackages = [ pkgs.hello ]; };
        }
      ''}"
    ))

    only_imperative.succeed("test 1 = \"$(nixos-nspawn list --json | jq 'length')\"")

    only_imperative.shutdown()
    imperative_and_declarative.shutdown()
  '';
})
