{
  lib,
  stdenv,
  lapack-reference,
  openblas,
  isILP64 ? false,
  lapackProvider ? openblas,
}:

let

  version = "3";
  canonicalExtension =
    if stdenv.hostPlatform.isLinux then
      "${stdenv.hostPlatform.extensions.sharedLibrary}.${version}"
    else
      stdenv.hostPlatform.extensions.sharedLibrary;

  lapackImplementation = lib.getName lapackProvider;
  lapackProvider' =
    if lapackImplementation == "mkl" then
      lapackProvider
    else
      lapackProvider.override { blas64 = isILP64; };

in

assert isILP64 -> lapackImplementation == "mkl" || lapackProvider'.blas64;

stdenv.mkDerivation {
  pname = "lapack";
  inherit version;

  outputs = [
    "out"
    "dev"
  ];

  meta = (lapackProvider'.meta or { }) // {
    description = "${lib.getName lapackProvider'} with just the LAPACK C and FORTRAN ABI";
  };

  passthru = {
    inherit isILP64;
    provider = lapackProvider';
    implementation = lapackImplementation;
  };

  # TODO: drop this forced rebuild, as it was needed just once.
  rebuild_salt =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then "J4AQ" else null;

  dontBuild = true;
  dontConfigure = true;
  unpackPhase = "src=$PWD";

  dontPatchELF = true;

  installPhase = (
    ''
      mkdir -p $out/lib $dev/include $dev/lib/pkgconfig

      liblapack="${lib.getLib lapackProvider'}/lib/liblapack${canonicalExtension}"

      if ! [ -e "$liblapack" ]; then
        echo "$liblapack does not exist, ${lapackProvider'.name} does not provide liblapack."
        exit 1
      fi

      cp -L "$liblapack" $out/lib/liblapack${canonicalExtension}
      chmod +w $out/lib/liblapack${canonicalExtension}

    ''
    + (lib.optionalString stdenv.hostPlatform.isElf ''
      patchelf --set-soname liblapack${canonicalExtension} $out/lib/liblapack${canonicalExtension}
      patchelf --set-rpath "$(patchelf --print-rpath $out/lib/liblapack${canonicalExtension}):${lapackProvider'}/lib" $out/lib/liblapack${canonicalExtension}
    '')
    + ''

        if [ "$out/lib/liblapack${canonicalExtension}" != "$out/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}" ]; then
          ln -s $out/lib/liblapack${canonicalExtension} "$out/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
        fi

        install -D ${lib.getDev lapack-reference}/include/lapack.h $dev/include/lapack.h

        cat <<EOF > $dev/lib/pkgconfig/lapack.pc
      Name: lapack
      Version: ${version}
      Description: LAPACK FORTRAN implementation
      Cflags: -I$dev/include
      Libs: -L$out/lib -llapack
      EOF

        liblapacke="${lib.getLib lapackProvider'}/lib/liblapacke${canonicalExtension}"

        if ! [ -e "$liblapacke" ]; then
          echo "$liblapacke does not exist, ${lapackProvider'.name} does not provide liblapacke."
          exit 1
        fi

        cp -L "$liblapacke" $out/lib/liblapacke${canonicalExtension}
        chmod +w $out/lib/liblapacke${canonicalExtension}

    ''
    + (lib.optionalString stdenv.hostPlatform.isElf ''
      patchelf --set-soname liblapacke${canonicalExtension} $out/lib/liblapacke${canonicalExtension}
      patchelf --set-rpath "$(patchelf --print-rpath $out/lib/liblapacke${canonicalExtension}):${lib.getLib lapackProvider'}/lib" $out/lib/liblapacke${canonicalExtension}
    '')
    + ''

        if [ -f "$out/lib/liblapacke.so.3" ]; then
          ln -s $out/lib/liblapacke.so.3 $out/lib/liblapacke.so
        fi

        cp ${lib.getDev lapack-reference}/include/lapacke{,_mangling,_config,_utils}.h $dev/include

        cat <<EOF > $dev/lib/pkgconfig/lapacke.pc
      Name: lapacke
      Version: ${version}
      Description: LAPACK C implementation
      Cflags: -I$dev/include
      Libs: -L$out/lib -llapacke
      EOF
    ''
    + lib.optionalString (lapackImplementation == "mkl") ''
      mkdir -p $out/nix-support
      echo 'export MKL_INTERFACE_LAYER=${lib.optionalString isILP64 "I"}LP64,GNU' > $out/nix-support/setup-hook
      ln -s $out/lib/liblapack${canonicalExtension} $out/lib/libmkl_rt${stdenv.hostPlatform.extensions.sharedLibrary}
      ln -sf ${lapackProvider'}/include/* $dev/include
    ''
  );
}
