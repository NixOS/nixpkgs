{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchurl,
  fftw,
  llvmPackages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmtk";
  version = "3.3.2";

  src = fetchurl {
    name = "cmtk-source.tar.gz";
    url = "https://www.nitrc.org/frs/download.php/13188/CMTK-${finalAttrs.version}-Source.tar.gz//?i_agree=1&download_now=1";
    hash = "sha256-iE164NCOSOypZLLZfZy9RTyrS+YnY9ECqfb4QhlsMS4=";
  };

  postPatch = ''
    substituteInPlace apps/vtkxform.cxx --replace-fail \
      "float xyzFloat[3] = { xyz[0], xyz[1], xyz[2] };" \
      "float xyzFloat[3] = { (float)xyz[0], (float)xyz[1], (float)xyz[2] };"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    bzip2
    fftw
    zlib
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "14")
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Dfinite=isfinite")
  ];

  meta = with lib; {
    description = "Computational Morphometry Toolkit";
    mainProgram = "cmtk";
    longDescription = ''
      A software toolkit for computational morphometry of
      biomedical images, CMTK comprises a set of command line tools and a
      back-end general-purpose library for processing and I/O
    '';
    maintainers = with maintainers; [ tbenst ];
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    homepage = "https://www.nitrc.org/projects/cmtk/";
  };
})
