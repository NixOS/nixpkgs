{ lib, stdenv, fetchFromGitHub, cmake
, fetchpatch
, openblas, blas, lapack, opencv3, libzip, boost, protobuf, mpi
, onebitSGDSupport ? false
, cudaSupport ? false, cudaPackages ? {}, addOpenGLRunpath, cudatoolkit, nvidia_x11
, cudnnSupport ? cudaSupport
}:

let
  inherit (cudaPackages) cudatoolkit cudnn;
in

assert cudnnSupport -> cudaSupport;
assert blas.implementation == "openblas" && lapack.implementation == "openblas";

let
  # Old specific version required for CNTK.
  cub = fetchFromGitHub {
    owner = "NVlabs";
    repo = "cub";
    rev = "1.7.4";
    sha256 = "0ksd5n1lxqhm5l5cd2lps4cszhjkf6gmzahaycs7nxb06qci8c66";
  };

in stdenv.mkDerivation rec {
  pname = "CNTK";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "CNTK";
    rev = "v${version}";
    sha256 = "sha256-2rIrPJyvZhnM5EO6tNhF6ARTocfUHce4N0IZk/SZiaI=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build with protobuf 3.18+
    # Remove with onnx submodule bump to 1.9+
    (fetchpatch {
      url = "https://github.com/onnx/onnx/commit/d3bc82770474761571f950347560d62a35d519d7.patch";
      extraPrefix = "Source/CNTKv2LibraryDll/proto/onnx/onnx_repo/";
      stripLen = 1;
      sha256 = "00raqj8wx30b06ky6cdp5vvc1mrzs7hglyi6h58hchw5lhrwkzxp";
    })
  ];

  postPatch = ''
    # Fix build with protobuf 3.18+
    substituteInPlace Source/CNTKv2LibraryDll/Serialization.cpp \
      --replace 'SetTotalBytesLimit(INT_MAX, INT_MAX)' \
                'SetTotalBytesLimit(INT_MAX)' \
      --replace 'SetTotalBytesLimit(limit, limit)' \
                'SetTotalBytesLimit(limit)'
  '';

  nativeBuildInputs = [ cmake ] ++ lib.optional cudaSupport addOpenGLRunpath;

  # Force OpenMPI to use g++ in PATH.
  OMPI_CXX = "g++";

  # Uses some deprecated tensorflow functions
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  buildInputs = [ openblas opencv3 libzip boost protobuf mpi ]
             ++ lib.optional cudaSupport cudatoolkit
             ++ lib.optional cudnnSupport cudnn;

  configureFlags = [
    "--with-opencv=${opencv3}"
    "--with-libzip=${libzip.dev}"
    "--with-openblas=${openblas.dev}"
    "--with-boost=${boost.dev}"
    "--with-protobuf=${protobuf}"
    "--with-mpi=${mpi}"
    "--cuda=${if cudaSupport then "yes" else "no"}"
    # FIXME
    "--asgd=no"
  ] ++ lib.optionals cudaSupport [
    "--with-cuda=${cudatoolkit}"
    "--with-gdk-include=${cudatoolkit}/include"
    "--with-gdk-nvml-lib=${nvidia_x11}/lib"
    "--with-cub=${cub}"
  ] ++ lib.optional onebitSGDSupport "--1bitsgd=yes";

  configurePhase = ''
    sed -i \
      -e 's,^GIT_STATUS=.*,GIT_STATUS=,' \
      -e 's,^GIT_COMMIT=.*,GIT_COMMIT=v${version},' \
      -e 's,^GIT_BRANCH=.*,GIT_BRANCH=v${version},' \
      -e 's,^BUILDER=.*,BUILDER=nixbld,' \
      -e 's,^BUILDMACHINE=.*,BUILDMACHINE=machine,' \
      -e 's,^BUILDPATH=.*,BUILDPATH=/homeless-shelter,' \
      -e '/git does not exist/d' \
      Tools/generate_build_info

    patchShebangs .
    mkdir build
    cd build
    ${lib.optionalString cudnnSupport ''
      mkdir cuda
      ln -s ${cudnn}/include cuda
      export configureFlags="$configureFlags --with-cudnn=$PWD"
    ''}

    ../configure $configureFlags
  '';

  installPhase = ''
    mkdir -p $out/bin
    # Moving to make patchelf remove references later.
    mv lib $out
    cp bin/cntk $out/bin
  '';

  postFixup = lib.optionalString cudaSupport ''
    for lib in $out/lib/*; do
      addOpenGLRunpath "$lib"
    done
  '';

  meta = with lib; {
    # Newer cub is included with cudatoolkit now and it breaks the build.
    # https://github.com/Microsoft/CNTK/issues/3191
    broken = cudaSupport;
    homepage = "https://github.com/Microsoft/CNTK";
    description = "An open source deep-learning toolkit";
    license = if onebitSGDSupport then licenses.unfreeRedistributable else licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
