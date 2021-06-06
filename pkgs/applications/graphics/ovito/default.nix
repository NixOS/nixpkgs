{ mkDerivation, lib, fetchFromGitLab, cmake
, boost, netcdf, hdf5, fftwSinglePrec, muparser, openssl, ffmpeg, python
, qtbase, qtsvg, qttools, qscintilla }:

mkDerivation rec {
  pname = "ovito";
  version = "3.4.0";

  src = fetchFromGitLab {
    owner = "stuko";
    repo = "ovito";
    rev = "v${version}";
    sha256 = "1y3wr6yzpsl0qm7cicp2mppfszxd0fgx8hm99in9wff9qd0r16b5";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    netcdf
    hdf5
    fftwSinglePrec
    muparser
    openssl
    ffmpeg
    python
    qtbase
    qtsvg
    qttools
    qscintilla
  ];

  meta = with lib; {
    description = "Scientific visualization and analysis software for atomistic and particle simulation data";
    homepage = "https://ovito.org";
    license = with licenses;  [ gpl3Only mit ];
    maintainers = with maintainers; [ twhitehead ];
  };
}
