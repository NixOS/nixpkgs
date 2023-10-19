{ lib, stdenv, fetchurl, cmake, blas, lapack, gfortran, gmm, fltk, libjpeg
, zlib, libGL, libGLU, xorg, opencascade-occt
, python ? null, enablePython ? false }:

assert (!blas.isILP64) && (!lapack.isILP64);
assert enablePython -> (python != null);

stdenv.mkDerivation rec {
  pname = "gmsh";
  version = "4.11.1";

  src = fetchurl {
    url = "https://gmsh.info/src/gmsh-${version}-source.tgz";
    sha256 = "sha256-xf4bfL1AOIioFJKfL9D11p4nYAIioYx4bbW3boAFs2U=";
  };

  buildInputs = [
    blas lapack gmm fltk libjpeg zlib opencascade-occt
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libGL libGLU xorg.libXrender xorg.libXcursor xorg.libXfixes
    xorg.libXext xorg.libXft xorg.libXinerama xorg.libX11 xorg.libSM
    xorg.libICE
  ] ++ lib.optional enablePython python;

  enableParallelBuilding = true;

  patches = [ ./fix-python.patch ];

  postPatch = ''
    substituteInPlace api/gmsh.py --subst-var-by LIBPATH ${placeholder "out"}/lib/libgmsh.so
  '';

  # N.B. the shared object is used by bindings
  cmakeFlags = [
    "-DENABLE_BUILD_SHARED=ON"
    "-DENABLE_BUILD_DYNAMIC=ON"
    "-DENABLE_OPENMP=ON"
  ];

  nativeBuildInputs = [ cmake gfortran ];

  postFixup = lib.optionalString enablePython ''
    mkdir -p $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/gmsh.py $out/lib/python${python.pythonVersion}/site-packages
    mv $out/lib/*.dist-info $out/lib/python${python.pythonVersion}/site-packages
  '';

  doCheck = true;

  meta = {
    description = "A three-dimensional finite element mesh generator";
    homepage = "https://gmsh.info/";
    license = lib.licenses.gpl2Plus;
  };
}
