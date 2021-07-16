# Builds an btrfs image containing a populated /nix/store with the closure
# of store paths passed in the storePaths parameter, in addition to the
# contents of a directory that can be populated with commands. The
# generated image is sized to only fit its contents, with the expectation
# that a script resizes the filesystem at boot time.
{ pkgs
, lib
# List of derivations to be included
, storePaths
# Shell commands to populate the ./files directory.
# All files in that directory are copied to the root of the FS.
, populateImageCommands ? ""
, volumeLabel
, uuid ? "44444444-4444-4444-8888-888888888888"
, btrfs-progs
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in
pkgs.stdenv.mkDerivation {
  name = "btrfs-fs.img";

  nativeBuildInputs = [ btrfs-progs ];

  buildCommand =
    ''
      set -x
      (
          mkdir -p ./files
          ${populateImageCommands}
      )

      mkdir -p ./files/nix/store
      cp ${sdClosureInfo}/registration ./files/nix-path-registration

      # Add the closures of the top-level store objects.
      for p in $(cat ${sdClosureInfo}/store-paths); do
        echo cp -r $p "./files/nix/store"
      done

      touch $out
      mkfs.btrfs -L ${volumeLabel} -U ${uuid} -r ./files --shrink $out
    '';
}
