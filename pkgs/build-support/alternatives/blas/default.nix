{ lib, stdenv
, lapack-reference, openblas
, isILP64 ? false
, blasProvider ? openblas }:

let
  blasFortranSymbols = [
    "caxpy" "ccopy" "cdotc" "cdotu" "cgbmv" "cgemm" "cgemv" "cgerc" "cgeru"
    "chbmv" "chemm" "chemv" "cher" "cher2" "cher2k" "cherk" "chpmv" "chpr"
    "chpr2" "crotg" "cscal" "csrot" "csscal" "cswap" "csymm" "csyr2k" "csyrk"
    "ctbmv" "ctbsv" "ctpmv" "ctpsv" "ctrmm" "ctrmv" "ctrsm" "ctrsv" "dasum"
    "daxpy" "dcabs1" "dcopy" "ddot" "dgbmv" "dgemm" "dgemv" "dger" "dnrm2"
    "drot" "drotg" "drotm" "drotmg" "dsbmv" "dscal" "dsdot" "dspmv" "dspr"
    "dspr2" "dswap" "dsymm" "dsymv" "dsyr" "dsyr2" "dsyr2k" "dsyrk" "dtbmv"
    "dtbsv" "dtpmv" "dtpsv" "dtrmm" "dtrmv" "dtrsm" "dtrsv" "dzasum" "dznrm2"
    "icamax" "idamax" "isamax" "izamax" "lsame" "sasum" "saxpy" "scabs1"
    "scasum" "scnrm2" "scopy" "sdot" "sdsdot" "sgbmv" "sgemm" "sgemv"
    "sger" "snrm2" "srot" "srotg" "srotm" "srotmg" "ssbmv" "sscal" "sspmv"
    "sspr" "sspr2" "sswap" "ssymm" "ssymv" "ssyr" "ssyr2" "ssyr2k" "ssyrk"
    "stbmv" "stbsv" "stpmv" "stpsv" "strmm" "strmv" "strsm" "strsv" "xerbla"
    "xerbla_array" "zaxpy" "zcopy" "zdotc" "zdotu" "zdrot" "zdscal" "zgbmv"
    "zgemm" "zgemv" "zgerc" "zgeru" "zhbmv" "zhemm" "zhemv" "zher" "zher2"
    "zher2k" "zherk" "zhpmv" "zhpr" "zhpr2" "zrotg" "zscal" "zswap" "zsymm"
    "zsyr2k" "zsyrk" "ztbmv" "ztbsv" "ztpmv" "ztpsv" "ztrmm" "ztrmv" "ztrsm"
    "ztrsv"
  ];

  version = "3";
  canonicalExtension = if stdenv.hostPlatform.isLinux
                       then "${stdenv.hostPlatform.extensions.sharedLibrary}.${version}"
                       else stdenv.hostPlatform.extensions.sharedLibrary;


  blasImplementation = lib.getName blasProvider;
  blasProvider' = if blasImplementation == "mkl"
                  then blasProvider
                  else blasProvider.override { blas64 = isILP64; };

in

assert isILP64 -> blasImplementation == "mkl" || blasProvider'.blas64;

stdenv.mkDerivation {
  pname = "blas";
  inherit version;

  outputs = [ "out" "dev" ];

  meta = (blasProvider'.meta or {}) // {
    description = "${lib.getName blasProvider} with just the BLAS C and FORTRAN ABI";
  };

  passthru = {
    inherit isILP64;
    provider = blasProvider';
    implementation = blasImplementation;
  };

  dontBuild = true;
  dontConfigure = true;
  unpackPhase = "src=$PWD";

  dontPatchELF = true;

  installPhase = (''
  mkdir -p $out/lib $dev/include $dev/lib/pkgconfig

  libblas="${lib.getLib blasProvider'}/lib/libblas${canonicalExtension}"

  if ! [ -e "$libblas" ]; then
    echo "$libblas does not exist, ${blasProvider'.name} does not provide libblas."
    exit 1
  fi

  $NM -an "$libblas" | cut -f3 -d' ' > symbols
  for symbol in ${toString blasFortranSymbols}; do
    grep -q "^$symbol_$" symbols || { echo "$symbol" was not found in "$libblas"; exit 1; }
  done

  cp -L "$libblas" $out/lib/libblas${canonicalExtension}
  chmod +w $out/lib/libblas${canonicalExtension}

'' + (if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf" then ''
  patchelf --set-soname libblas${canonicalExtension} $out/lib/libblas${canonicalExtension}
  patchelf --set-rpath "$(patchelf --print-rpath $out/lib/libblas${canonicalExtension}):${lib.getLib blasProvider'}/lib" $out/lib/libblas${canonicalExtension}
'' else if stdenv.hostPlatform.isDarwin then ''
  install_name_tool \
    -id $out/lib/libblas${canonicalExtension} \
    -add_rpath ${lib.getLib blasProvider'}/lib \
    $out/lib/libblas${canonicalExtension}
'' else "") + ''

  if [ "$out/lib/libblas${canonicalExtension}" != "$out/lib/libblas${stdenv.hostPlatform.extensions.sharedLibrary}" ]; then
    ln -s $out/lib/libblas${canonicalExtension} "$out/lib/libblas${stdenv.hostPlatform.extensions.sharedLibrary}"
  fi

  cat <<EOF > $dev/lib/pkgconfig/blas.pc
Name: blas
Version: ${version}
Description: BLAS FORTRAN implementation
Libs: -L$out/lib -lblas
Cflags: -I$dev/include
EOF

  libcblas="${lib.getLib blasProvider'}/lib/libcblas${canonicalExtension}"

  if ! [ -e "$libcblas" ]; then
    echo "$libcblas does not exist, ${blasProvider'.name} does not provide libcblas."
    exit 1
  fi

  cp -L "$libcblas" $out/lib/libcblas${canonicalExtension}
  chmod +w $out/lib/libcblas${canonicalExtension}

'' + (if stdenv.hostPlatform.parsed.kernel.execFormat.name == "elf" then ''
  patchelf --set-soname libcblas${canonicalExtension} $out/lib/libcblas${canonicalExtension}
  patchelf --set-rpath "$(patchelf --print-rpath $out/lib/libcblas${canonicalExtension}):${lib.getLib blasProvider'}/lib" $out/lib/libcblas${canonicalExtension}
'' else if stdenv.hostPlatform.isDarwin then ''
  install_name_tool \
    -id $out/lib/libcblas${canonicalExtension} \
    -add_rpath ${lib.getLib blasProvider'}/lib \
    $out/lib/libcblas${canonicalExtension}
'' else "") + ''
  if [ "$out/lib/libcblas${canonicalExtension}" != "$out/lib/libcblas${stdenv.hostPlatform.extensions.sharedLibrary}" ]; then
    ln -s $out/lib/libcblas${canonicalExtension} "$out/lib/libcblas${stdenv.hostPlatform.extensions.sharedLibrary}"
  fi

  cp ${lib.getDev lapack-reference}/include/cblas{,_mangling}.h $dev/include

  cat <<EOF > $dev/lib/pkgconfig/cblas.pc
Name: cblas
Version: ${version}
Description: BLAS C implementation
Cflags: -I$dev/include
Libs: -L$out/lib -lcblas
EOF
'' + lib.optionalString (blasImplementation == "mkl") ''
  mkdir -p $out/nix-support
  echo 'export MKL_INTERFACE_LAYER=${lib.optionalString isILP64 "I"}LP64,GNU' > $out/nix-support/setup-hook
  ln -s $out/lib/libblas${canonicalExtension} $out/lib/libmkl_rt${stdenv.hostPlatform.extensions.sharedLibrary}
  ln -sf ${blasProvider'}/include/* $dev/include
'');
}
