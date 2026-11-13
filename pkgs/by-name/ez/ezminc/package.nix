{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  perl,
  libminc,
  bicpl,
  itk_5_2,
  fftwFloat,
  gsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "EZminc";
  version = "2.2.00-unstable-2023-10-06";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "EZminc";
    rev = "5fdf112e837000d155891e423041d7065ea13c3f";
    hash = "sha256-0KdFIWRHnIHrau0ysGMVpg3oz01UdIvna1y2I4YEWJw=";
  };

  postPatch = ''
    patchShebangs scripts/*
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    itk_5_2
    libminc
    bicpl
    fftwFloat
    gsl
    perl
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEZMINC_BUILD_TOOLS=TRUE"
    "-DEZMINC_BUILD_MRFSEG=TRUE"
    # "-DEZMINC_BUILD_DD=TRUE" # numerous compilation issues
  ];

  doCheck = false; # test programs/data exist but no actual test harness

  meta = {
    homepage = "https://github.com/BIC-MNI/EZminc";
    description = "Collection of Perl and shell scripts for processing MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.linux; # can't detect opengl on Darwin
    license = lib.licenses.free;
  };
})
