{ lib, stdenv
, lapack-reference, openblasCompat, openblas
, is64bit ? false
, lapackProvider ? if is64bit then openblas else openblasCompat }:

let

  version = "3";
  canonicalExtension = if stdenv.hostPlatform.isLinux
                       then "${stdenv.hostPlatform.extensions.sharedLibrary}.${version}"
                       else stdenv.hostPlatform.extensions.sharedLibrary;

  lapackImplementation = lib.getName lapackProvider;

in

assert is64bit -> (lapackImplementation == "openblas" && lapackProvider.blas64) || lapackImplementation == "mkl";

stdenv.mkDerivation {
  pname = "lapack";
  inherit version;

  outputs = [ "out" "dev" ];

  meta = (lapackProvider.meta or {}) // {
    description = "${lib.getName lapackProvider} with just the LAPACK C and FORTRAN ABI";
  };

  passthru = {
    inherit is64bit;
    provider = lapackProvider;
    implementation = lapackImplementation;
  };

  dontBuild = true;
  dontConfigure = true;
  unpackPhase = "src=$PWD";

  installPhase = (''
  mkdir -p $out/lib $dev/include $dev/lib/pkgconfig

  liblapack="${lib.getLib lapackProvider}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"

  if ! [ -e "$liblapack" ]; then
    echo "$liblapack does not exist, ${lapackProvider.name} does not provide liblapack."
    exit 1
  fi

  cp -L "$liblapack" $out/lib/liblapack${canonicalExtension}
  chmod +w $out/lib/liblapack${canonicalExtension}

'' + (if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf" then ''
  patchelf --set-soname liblapack${canonicalExtension} $out/lib/liblapack${canonicalExtension}
  patchelf --set-rpath "$(patchelf --print-rpath $out/lib/liblapack${canonicalExtension}):${lapackProvider}/lib" $out/lib/liblapack${canonicalExtension}
'' else if stdenv.hostPlatform.isDarwin then ''
  install_name_tool -id liblapack${canonicalExtension} \
                    -add_rpath ${lib.getLib lapackProvider}/lib \
                    $out/lib/liblapack${canonicalExtension}
'' else "") + ''

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

  liblapacke="${lib.getLib lapackProvider}/lib/liblapacke${stdenv.hostPlatform.extensions.sharedLibrary}"

  if ! [ -e "$liblapacke" ]; then
    echo "$liblapacke does not exist, ${lapackProvider.name} does not provide liblapacke."
    exit 1
  fi

  cp -L "$liblapacke" $out/lib/liblapacke${canonicalExtension}
  chmod +w $out/lib/liblapacke${canonicalExtension}

'' + (if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf" then ''
  patchelf --set-soname liblapacke${canonicalExtension} $out/lib/liblapacke${canonicalExtension}
  patchelf --set-rpath "$(patchelf --print-rpath $out/lib/liblapacke${canonicalExtension}):${lib.getLib lapackProvider}/lib" $out/lib/liblapacke${canonicalExtension}
'' else if stdenv.hostPlatform.isDarwin then ''
  install_name_tool -id liblapacke${canonicalExtension} \
                    -add_rpath ${lib.getLib lapackProvider}/lib \
                    $out/lib/liblapacke${canonicalExtension}
'' else "") + ''

  if [ -f "$out/lib/liblapacke.so.3" ]; then
    ln -s $out/lib/liblapacke.so.3 $out/lib/liblapacke.so
  fi

  cp ${lib.getDev lapack-reference}/include/lapacke{,_mangling,_config}.h $dev/include

  cat <<EOF > $dev/lib/pkgconfig/lapacke.pc
Name: lapacke
Version: ${version}
Description: LAPACK C implementation
Cflags: -I$dev/include
Libs: -L$out/lib -llapacke
EOF
'' + stdenv.lib.optionalString (lapackImplementation == "mkl") ''
  mkdir -p $out/nix-support
  echo 'export MKL_INTERFACE_LAYER=${lib.optionalString is64bit "I"}LP64,GNU' > $out/nix-support/setup-hook
'');
}
