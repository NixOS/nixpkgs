{ stdenv, squashfsTools, closureInfo

, # The root directory of the squashfs filesystem is filled with the
  # closures of the Nix store paths listed here.
  storeContents ? []
}:

stdenv.mkDerivation {
  name = "squashfs.img";

  nativeBuildInputs = [ squashfsTools ];

  buildCommand =
    ''
      closureInfo=${closureInfo { rootPaths = storeContents; }}

      # Also include a manifest of the closures in a format suitable
      # for nix-store --load-db.
      cp $closureInfo/registration nix-path-registration

      # Generate the squashfs image.
      mksquashfs nix-path-registration $(cat $closureInfo/store-paths) $out \
        -keep-as-directory -all-root -b 1048576 -comp xz -Xdict-size 100%
    '';
}
