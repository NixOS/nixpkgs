{ mkDerivation
, lib
, stdenv
, fetchFromGitLab
, cmake
, boost
, bzip2
, ffmpeg
, fftwSinglePrec
, hdf5
, muparser
, netcdf
, openssl
, python3
, qscintilla
, qtbase
, qtsvg
, qttools
, VideoDecodeAcceleration
}:

mkDerivation rec {
  pname = "ovito";
  version = "3.7.11";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = "ovito";
    rev = "v${version}";
    sha256 = "sha256-Z3uwjOYJ7di/LLllbzdKjzUE7m119i03bA8dJPqhxWA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    bzip2
    ffmpeg
    fftwSinglePrec
    hdf5
    muparser
    netcdf
    openssl
    python3
    qscintilla
    qtbase
    qtsvg
    qttools
  ] ++ lib.optionals stdenv.isDarwin [
    VideoDecodeAcceleration
  ];

  meta = with lib; {
    description = "Scientific visualization and analysis software for atomistic and particle simulation data";
    mainProgram = "ovito";
    homepage = "https://ovito.org";
    license = with licenses;  [ gpl3Only mit ];
    maintainers = with maintainers; [ twhitehead ];
    broken = stdenv.isDarwin; # clang-11: error: no such file or directory: '$-DOVITO_COPYRIGHT_NOTICE=...
  };
}
