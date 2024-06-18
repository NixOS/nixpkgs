# Builds an btrfs image containing a populated /nix/store with the closure
# of store paths passed in the storePaths parameter, in addition to the
# contents of a directory that can be populated with commands. The
# generated image is sized to only fit its contents, with the expectation
# that a script resizes the filesystem at boot time.
{ pkgs
, lib
# List of derivations to be included
, storePaths
# Whether or not to compress the resulting image with zstd
, compressImage ? false, zstd
# Shell commands to populate the ./files directory.
# All files in that directory are copied to the root of the FS.
, populateImageCommands ? ""
, volumeLabel
, uuid ? "44444444-4444-4444-8888-888888888888"
, btrfs-progs
, libfaketime
, fakeroot
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in
pkgs.stdenv.mkDerivation {
  name = "btrfs-fs.img${lib.optionalString compressImage ".zst"}";

  nativeBuildInputs = [ btrfs-progs libfaketime fakeroot ] ++ lib.optional compressImage zstd;

  buildCommand =
    ''
      ${if compressImage then "img=temp.img" else "img=$out"}

      set -x
      (
          mkdir -p ./files
          ${populateImageCommands}
      )

      mkdir -p ./rootImage/nix/store

      xargs -I % cp -a --reflink=auto % -t ./rootImage/nix/store/ < ${sdClosureInfo}/store-paths
      (
        GLOBIGNORE=".:.."
        shopt -u dotglob

        for f in ./files/*; do
            cp -a --reflink=auto -t ./rootImage/ "$f"
        done
      )

      cp ${sdClosureInfo}/registration ./rootImage/nix-path-registration

      touch $img
      faketime -f "1970-01-01 00:00:01" fakeroot mkfs.btrfs -L ${volumeLabel} -U ${uuid} -r ./rootImage --shrink $img

      if ! btrfs check $img; then
        echo "--- 'btrfs check' failed for BTRFS image ---"
        return 1
      fi

      if [ ${builtins.toString compressImage} ]; then
        echo "Compressing image"
        zstd -v --no-progress ./$img -o $out
      fi
    '';
}
