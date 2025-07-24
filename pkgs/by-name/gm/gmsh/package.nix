{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  blas,
  lapack,
  gfortran,
  gmm,
  fltk,
  libjpeg,
  zlib,
  libGL,
  libGLU,
  xorg,
  opencascade-occt,
  llvmPackages,
  python ? null,
  enablePython ? false,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert enablePython -> (python != null);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.13.1";

  src = fetchurl {
    url = "https://gmsh.info/src/gmsh-${version}-source.tgz";
    hash = "sha256-d5chRfQxcmAm1QWWpqRPs8HJXCElUhjWaVWAa4btvo0=";
  };

  buildInputs = [
    blas
    lapack
    gmm
    fltk
    libjpeg
    zlib
    opencascade-occt
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
    xorg.libXrender
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXext
    xorg.libXft
    xorg.libXinerama
    xorg.libX11
    xorg.libSM
    xorg.libICE
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
  ++ lib.optional enablePython python;

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      url = "https://gitlab.onelab.info/gmsh/gmsh/-/commit/7d5094fb0a5245cb435afd3f3e8c35e2ecfe70fd.patch";
      hash = "sha256-3atm1NGsMI4KEct2xakRG6EasRpF6YRI4raoVYxBV4g=";
    })
  ];

  postPatch = ''
    substituteInPlace api/gmsh.py \
      --replace-fail 'find_library("gmsh")' \"$out/lib/libgmsh${stdenv.hostPlatform.extensions.sharedLibrary}\"
  '';

  # N.B. the shared object is used by bindings
  cmakeFlags = [
    "-DENABLE_BUILD_SHARED=ON"
    "-DENABLE_BUILD_DYNAMIC=ON"
    "-DENABLE_OPENMP=ON"
  ];

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  postFixup = lib.optionalString enablePython ''
    mkdir -p $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/gmsh.py $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/*.dist-info $out/lib/python${python.pythonVersion}/site-packages
  '';

  doCheck = true;

  meta = {
    description = "Three-dimensional finite element mesh generator";
    mainProgram = "gmsh";
    homepage = "https://gmsh.info/";
    license = lib.licenses.gpl2Plus;
  };
}
