# Given a Nixpkgs, `assert` relevant properties of NixOS container evaluation
# that aren't exercised by the test framework, such as checking the `assertions`,
# which makes `toplevel` invalid.
#
# Run tests with:
#   nix-build -A nixosTests.containers-eval
{
  pkgs,
  lib ? pkgs.lib,
}:

let
  inherit (lib) concatMap optionals;

  test = rec {
    nixos =
      m:
      pkgs.nixos {
        imports = [ m ];
        boot.loader.grub.enable = false;
        fileSystems."/".device = "bogus";
        fileSystems."/".fsType = "bogusfs";
        system.stateVersion = lib.trivial.release;
      };

    # we'd rather have all messages ready for display than show thunks and length mismatch
    deepSeqId = a: builtins.deepSeq a a;

    assertionMessages =
      configuration:
      deepSeqId (
        concatMap (ass: optionals (!ass.assertion) [ ass.message ]) configuration.config.assertions
      );

    flakeContainerOnHostWithoutNix = nixos {
      nix.enable = false;
      containers.foo.flake = "github:NixOS/fake-repo";

      # - Does not need nix for startup like flake.
      # - We can't know whether it needs a socket, so we just let this pass.
      # So via_path should eval without assertions.
      containers.via_path.path = "/nix/var/nix/profiles/per-container/foo";
    };

    flakeContainerOnHostWithoutNixDaemon = nixos {
      nix.daemon.enable = false;

      # This should eval fine. The host needs nix, but we can't know now whether
      # the specified container needs a nix daemon socket.
      containers.foo.flake = "github:NixOS/fake-repo";

      # This container does not disable its daemon socket, so this could be a
      # problem and we should report it.
      containers.bar.config = {
      };
    };

    conflictingNetwork = nixos {
      containers.foo.networkNamespace = "/foons";
      containers.foo.interfaces = [ "veth67" ];
      containers.foo.config = { };
    };

    result =
      assert
        assertionMessages flakeContainerOnHostWithoutNix == [
          "containers.foo.flake is defined, so the container is built with nix on the host, but nix.enable is disabled"
        ];
      assert
        assertionMessages flakeContainerOnHostWithoutNixDaemon == [
          "containers.bar has nix.daemon.enable = true, but the host does not provide a nix daemon socket, as host option nix.daemon.enable is disabled. Disable nix.daemon.enable in the container, or enable the daemon on the host."
        ];
      assert
        assertionMessages conflictingNetwork == [
          "containers.foo.networkNamespace is mutally exclusive to containers.foo.privateNetwork and containers.foo.interfaces."
        ];

      pkgs.emptyFile // { details = test; };
  };
in
test.result
