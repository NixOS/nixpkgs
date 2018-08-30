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
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in

pkgs.stdenv.mkDerivation {
  name = "ext4-fs.img";

  nativeBuildInputs = [e2fsprogs.bin libfaketime perl];

  buildCommand =
    ''
      # Add the closures of the top-level store objects.
      storePaths=$(cat ${sdClosureInfo}/store-paths)

      # Also include a manifest of the closures in a format suitable for nix-store --load-db.
      cp ${sdClosureInfo}/registration nix-path-registration

      # Make a crude approximation of the size of the target image.
      # If the script starts failing, increase the fudge factors here.
      numInodes=$(find $storePaths | wc -l)
      numDataBlocks=$(du -c -B 4096 --apparent-size $storePaths | awk '$2 == "total" { print int($1 * 1.03) }')
      bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
      echo "Creating an EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

      truncate -s $bytes $out
      faketime -f "1970-01-01 00:00:01" mkfs.ext4 -L ${volumeLabel} -U ${uuid} $out

      # Populate the image contents by piping a bunch of commands to the `debugfs` tool from e2fsprogs.
      # For example, to copy /nix/store/abcd...efg-coreutils-8.23/bin/sleep:
      #   cd /nix/store/abcd...efg-coreutils-8.23/bin
      #   write /nix/store/abcd...efg-coreutils-8.23/bin/sleep sleep
      #   sif sleep mode 040555
      #   sif sleep gid 30000
      # In particular, debugfs doesn't handle absolute target paths; you have to 'cd' in the virtual
      # filesystem first. Likewise the intermediate directories must already exist (using `find`
      # handles that for us). And when setting the file's permissions, the inode type flags (__S_IFDIR,
      # __S_IFREG) need to be set as well.
      (
        echo write nix-path-registration nix-path-registration
        echo mkdir nix
        echo cd /nix
        echo mkdir store

        # XXX: This explodes in exciting ways if anything in /nix/store has a space in it.
        find $storePaths -printf '%y %f %h %m\n'| while read -r type file dir perms; do
          # echo "TYPE=$type DIR=$dir FILE=$file PERMS=$perms" >&2

          echo "cd $dir"
          case $type in
            d)
              echo "mkdir $file"
              echo sif $file mode $((040000 | 0$perms)) # magic constant is __S_IFDIR
              ;;
            f)
              echo "write $dir/$file $file"
              echo sif $file mode $((0100000 | 0$perms)) # magic constant is __S_IFREG
              ;;
            l)
              echo "symlink $file $(readlink "$dir/$file")"
              ;;
            *)
              echo "Unknown entry: $type $dir $file $perms" >&2
              exit 1
              ;;
          esac

          echo sif $file gid 30000 # chgrp to nixbld
        done
      ) | faketime -f "1970-01-01 00:00:01" debugfs -w $out -f /dev/stdin > errorlog 2>&1

      # The debugfs tool doesn't terminate on error nor exit with a non-zero status. Check manually.
      if egrep -q 'Could not allocate|File not found' errorlog; then
        cat errorlog
        echo "--- Failed to create EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        return 1
      fi

      # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
      if ! fsck.ext4 -n -f $out; then
        echo "--- Fsck failed for EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        cat errorlog
        return 1
      fi
    '';
}
