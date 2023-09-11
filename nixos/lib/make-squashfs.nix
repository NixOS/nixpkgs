{ lib, stdenv, squashfsTools, closureInfo

, # The root directory of the squashfs filesystem is filled with the
  # closures of the Nix store paths listed here.
  storeContents ? []
, # Compression parameters.
  # For zstd compression you can use "zstd -Xcompression-level 6".
  comp ? "xz -Xdict-size 100%"
}:

stdenv.mkDerivation {
  name = "squashfs.img";
  __structuredAttrs = true;

  nativeBuildInputs = [ squashfsTools ];

  buildCommand =
    ''
      closureInfo=${closureInfo { rootPaths = storeContents; }}

      # Also include a manifest of the closures in a format suitable
      # for nix-store --load-db.
      cp $closureInfo/registration nix-path-registration

    '' + lib.optionalString stdenv.buildPlatform.is32bit ''
      # 64 cores on i686 does not work
      # fails with FATAL ERROR: mangle2:: xz compress failed with error code 5
      if ((NIX_BUILD_CORES > 48)); then
        NIX_BUILD_CORES=48
      fi
    '' + ''

      # Generate the squashfs image.
      mksquashfs nix-path-registration $(cat $closureInfo/store-paths) $out \
        -no-hardlinks -keep-as-directory -all-root -b 1048576 -comp ${comp} \
        -processors $NIX_BUILD_CORES
    '';
}
