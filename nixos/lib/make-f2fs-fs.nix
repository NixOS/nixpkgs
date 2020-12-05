# Builds an f2fs image containing a populated /nix/store with the closure
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
, f2fs-tools
, perl
, fakeroot
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in
pkgs.stdenv.mkDerivation {
  name = "f2fs-fs.img${lib.optionalString compressImage ".zst"}";

  nativeBuildInputs = [ f2fs-tools perl fakeroot ]
  ++ lib.optional compressImage zstd;

  buildCommand =
    ''
      ${if compressImage then "img=temp.img" else "img=$out"}
      (
      mkdir -p ./files
      ${populateImageCommands}
      )

      echo "Preparing store paths for image..."

      # Create nix/store before copying path
      mkdir -p ./rootImage/nix/store

      xargs -I % cp -a --reflink=auto % -t ./rootImage/nix/store/ < ${sdClosureInfo}/store-paths
      (
        GLOBIGNORE=".:.."
        shopt -u dotglob

        for f in ./files/*; do
            cp -a --reflink=auto -t ./rootImage/ "$f"
        done
      )

      # Also include a manifest of the closures in a format suitable for nix-store --load-db
      cp ${sdClosureInfo}/registration ./rootImage/nix-path-registration

      # Make a crude approximation of the size of the target image.
      # If the script starts failing, increase the fudge factors here.
      numInodes=$(find ./rootImage | wc -l)
      numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootImage | tail -1 | awk '{ print int($1 * 1.10) }')
      bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
      echo "Creating an f2fs image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

      truncate -s $bytes $img

      mkfs.f2fs -l ${volumeLabel} -U ${uuid} -T 1 $img
      fakeroot sload.f2fs -T 1 -f ./rootImage $img

      # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
      if ! fsck.f2fs $img; then
        echo "--- Fsck failed for f2fs image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        cat errorlog
        return 1
      fi

      if [ ${builtins.toString compressImage} ]; then
        echo "Compressing image"
        zstd -v --no-progress ./$img -o $out
      fi
    '';
}
