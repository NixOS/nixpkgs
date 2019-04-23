# Builds an ext4 image containing a populated /nix/store with the closure
# of store paths passed in the storePaths parameter. The generated image
# is sized to only fit its contents, with the expectation that a script
# resizes the filesystem at boot time.
{ pkgs
, storePaths
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
  name = "ext4-fs.img";

  nativeBuildInputs = [e2fsprogs.bin libfaketime perl lkl];

  buildCommand =
    ''
      # Add the closures of the top-level store objects.
      storePaths=$(cat ${sdClosureInfo}/store-paths)

      # Make a crude approximation of the size of the target image.
      # If the script starts failing, increase the fudge factors here.
      numInodes=$(find $storePaths | wc -l)
      numDataBlocks=$(du -c -B 4096 --apparent-size $storePaths | awk '$2 == "total" { print int($1 * 1.03) }')
      bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
      echo "Creating an EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

      truncate -s $bytes $out
      faketime -f "1970-01-01 00:00:01" mkfs.ext4 -L ${volumeLabel} -U ${uuid} $out

      # Also include a manifest of the closures in a format suitable for nix-store --load-db.
      cp ${sdClosureInfo}/registration nix-path-registration
      cptofs -t ext4 -i $out nix-path-registration /

      # Create nix/store before copying paths
      faketime -f "1970-01-01 00:00:01" mkdir -p nix/store
      cptofs -t ext4 -i $out nix /

      echo "copying store paths to image..."
      cptofs -t ext4 -i $out $storePaths /nix/store/

      # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
      if ! fsck.ext4 -n -f $out; then
        echo "--- Fsck failed for EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        cat errorlog
        return 1
      fi

      (
        # Resizes **snugly** to its actual limits (or closer to)
        free=$(dumpe2fs $out | grep '^Free blocks:')
        blocksize=$(dumpe2fs $out | grep '^Block size:')
        blocks=$(dumpe2fs $out | grep '^Block count:')
        blocks=$((''${blocks##*:})) # format the number.
        blocksize=$((''${blocksize##*:})) # format the number.
        # System can't boot with 0 blocks free.
        # Add 16MiB of free space
        fudge=$(( 16 * 1024 * 1024 / blocksize ))
        size=$(( blocks - ''${free##*:} + fudge ))

        echo "Resizing from $blocks blocks to $size blocks. (~ $((size*blocksize/1024/1024))MiB)"
        EXT2FS_NO_MTAB_OK=yes resize2fs $out -f $size
      )

      # And a final fsck, because of the previous truncating.
      fsck.ext4 -n -f $out
    '';
}
