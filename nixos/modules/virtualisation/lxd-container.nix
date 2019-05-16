{ lib, config, pkgs, ... }:

# Partially taken from ../profilers/docker-container.nix
# TODO: Rework module hierarchy to provide a generic “open container
# profile.

let

  # Can’t find official documentation for this?
  # Found some info here:
  # https://github.com/lxc/lxd/blob/master/doc/image-handling.md#content
  # But no comprehensive docs. They must be somewhere!
  metadata = {
    architecture = pkgs.stdenv.hostPlatform.parsed.cpu.name;
    creation_date = 0;
    properties = rec {
      os = "NixOS";
      description = "${os} ${lib.trivial.codeName} ${lib.version}";
      inherit (lib.trivial) release;
    };
  };

  pkgs2storeContents = map (x: { object = x; symlink = "none"; });

in {
  imports = [ ./lxc-container.nix ];

  system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
    contents = [
      {
        source = "${config.system.build.toplevel}/.";
        target = "./rootfs";
      }
    ];
    extraArgs = "--owner=0";

    # Add init script to image
    storeContents = pkgs2storeContents [
      config.system.build.toplevel pkgs.stdenv
    ];

    extraCommands = ''
      # Some container managers like lxc need these
      mkdir -p rootfs/proc rootfs/sys rootfs/dev

      cp ${builtins.toFile "metadata.yaml" (lib.generators.toYAML {} metadata)} metadata.yaml
    '';
  };

}
