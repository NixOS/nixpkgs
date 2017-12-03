{ stdenv, squashfsTools, perl, pathsFromGraph

, # The root directory of the squashfs filesystem is filled with the
  # closures of the Nix store paths listed here.
  storeContents ? []
}:

stdenv.mkDerivation {
  name = "squashfs.img";

  buildInputs = [perl squashfsTools];

  # For obtaining the closure of `storeContents'.
  exportReferencesGraph =
    map (x: [("closure-" + baseNameOf x) x]) storeContents;

  buildCommand =
    ''
      # Add the closures of the top-level store objects.
      storePaths=$(perl ${pathsFromGraph} closure-*)

      # If a Hydra slave happens to have store paths with bad permissions/mtime,
      # abort now so that they don't end up in ISO images in the channel.
      # https://github.com/NixOS/nixpkgs/issues/32242
      hasBadPaths=""
      for path in $storePaths; do
        if [ -h "$path" ]; then
          continue
        fi

        mtime=$(stat -c %Y "$path")
        mode=$(stat -c %a "$path")

        if [ "$mtime" != 1 ]; then
          echo "Store path '$path' has an invalid mtime."
          hasBadPaths=1
        fi
        if [ "$mode" != 444 ] && [ "$mode" != 555 ]; then
          echo "Store path '$path' has invalid permissions."
          hasBadPaths=1
        fi
      done

      if [ -n "$hasBadPaths" ]; then
        echo "You have bad paths in your store, please fix them."
        exit 1
      fi

      # Also include a manifest of the closures in a format suitable
      # for nix-store --load-db.
      printRegistration=1 perl ${pathsFromGraph} closure-* > nix-path-registration

      # Generate the squashfs image.
      mksquashfs nix-path-registration $storePaths $out \
        -keep-as-directory -all-root -b 1048576 -comp xz -Xdict-size 100%
    '';
}
