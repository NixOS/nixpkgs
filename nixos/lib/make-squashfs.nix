{ lib, stdenv, squashfsTools, closureInfo

,  fileName ? "squashfs"
, # The root directory of the squashfs filesystem is filled with the
  # closures of the Nix store paths listed here.
  storeContents ? []
  # Pseudo files to be added to squashfs image
, pseudoFiles ? []
, noStrip ? false
, # Compression parameters.
  # For zstd compression you can use "zstd -Xcompression-level 6".
  comp ? "xz -Xdict-size 100%"
, # create hydra build product. will put image in directory instead
  # of directly in the store
  hydraBuildProduct ? false
}:

let
  pseudoFilesArgs = lib.concatMapStrings (f: ''-p "${f}" '') pseudoFiles;
  compFlag = if comp == null then "-no-compression" else "-comp ${comp}";
in
stdenv.mkDerivation {
  name = "${fileName}${lib.optionalString (!hydraBuildProduct) ".img"}";
  __structuredAttrs = true;

  nativeBuildInputs = [ squashfsTools ];

  buildCommand =
    ''
      closureInfo=${closureInfo { rootPaths = storeContents; }}

      # Also include a manifest of the closures in a format suitable
      # for nix-store --load-db.
      cp $closureInfo/registration nix-path-registration

      imgPath="$out"
    '' + lib.optionalString hydraBuildProduct ''

      mkdir $out
      imgPath="$out/${fileName}.squashfs"
    '' + lib.optionalString stdenv.buildPlatform.is32bit ''

      # 64 cores on i686 does not work
      # fails with FATAL ERROR: mangle2:: xz compress failed with error code 5
      if ((NIX_BUILD_CORES > 48)); then
        NIX_BUILD_CORES=48
      fi
    '' + ''

      # Generate the squashfs image.
      mksquashfs nix-path-registration $(cat $closureInfo/store-paths) $imgPath ${pseudoFilesArgs} \
        -no-hardlinks ${lib.optionalString noStrip "-no-strip"} -keep-as-directory -all-root -b 1048576 ${compFlag} \
        -processors $NIX_BUILD_CORES -root-mode 0755
    '' + lib.optionalString hydraBuildProduct ''

      mkdir -p $out/nix-support
      echo "file squashfs-image $out/${fileName}.squashfs" >> $out/nix-support/hydra-build-products
    '';
}
