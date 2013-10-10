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

      # Also include a manifest of the closures in a format suitable
      # for nix-store --load-db.
      printRegistration=1 perl ${pathsFromGraph} closure-* > nix-path-registration

      # Generate the squashfs image.
      mksquashfs nix-path-registration $storePaths $out \
        -keep-as-directory -all-root
    '';
}
