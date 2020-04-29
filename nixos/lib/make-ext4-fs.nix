# Builds an ext4 image containing a populated /nix/store with the closure
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
, e2fsprogs
, libfaketime
, perl
, lkl
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in
pkgs.stdenv.mkDerivation {
  name = "ext4-fs.img${lib.optionalString compressImage ".zst"}";

  nativeBuildInputs = [ e2fsprogs.bin libfaketime perl lkl ]
  ++ lib.optional compressImage zstd;

  buildCommand =
    ''
      ${if compressImage then "img=temp.img" else "img=$out"}
      (
      mkdir -p ./files
      ${populateImageCommands}
      )

      # Add the closures of the top-level store objects.
      storePaths=$(cat ${sdClosureInfo}/store-paths)

      # Make a crude approximation of the size of the target image.
      # If the script starts failing, increase the fudge factors here.
      numInodes=$(find $storePaths ./files | wc -l)
      numDataBlocks=$(du -s -c -B 4096 --apparent-size $storePaths ./files | tail -1 | awk '{ print int($1 * 1.03) }')
      bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
      echo "Creating an EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

      truncate -s $bytes $img
      faketime -f "1970-01-01 00:00:01" mkfs.ext4 -L ${volumeLabel} -U ${uuid} $img

      # Also include a manifest of the closures in a format suitable for nix-store --load-db.
      cp ${sdClosureInfo}/registration nix-path-registration
      cptofs -t ext4 -i $img nix-path-registration /

      # Create nix/store before copying paths
      faketime -f "1970-01-01 00:00:01" mkdir -p nix/store
      cptofs -t ext4 -i $img nix /

      echo "copying store paths to image..."
      cptofs -t ext4 -i $img $storePaths /nix/store/

      echo "copying files to image..."
      cptofs -t ext4 -i $img ./files/* /

      export EXT2FS_NO_MTAB_OK=yes
      # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
      if ! fsck.ext4 -n -f $img; then
        echo "--- Fsck failed for EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        cat errorlog
        return 1
      fi

      echo "Resizing to minimum allowed size"
      # The previous fsck is executed read-only, and it doesn't update the timestamp bundled
      # in the EXT filesystem which holds the time it was last checked. If resize2fs is run
      # without the -f flag, it would fail since it only allows to run if the file system was
      # checked after its last mount. Since the filesystem was deemed safe by fsck immediately
      # before, we can safely let resize2fs skip these checks.
      # Note that due to a regression in cptofs and some other fortunate coincidences this worked
      # before, but it will break when the regression in LKL is fixed.
      resize2fs -f -M $img

      # And a final fsck, because of the previous truncating.
      fsck.ext4 -n -f $img

      if [ ${builtins.toString compressImage} ]; then
        echo "Compressing image"
        zstd -v --no-progress ./$img -o $out
      fi
    '';
}
