{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cairo
, libX11
, libjack2
, liblo
, libsigcxx
, zita-resampler
, fftwFloat
}:

stdenv.mkDerivation rec {
  pname = "xtuner";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "XTuner";
    rev = "v${version}";
    sha256 = "1i5chfnf3hcivwzni9z6cn9pb68qmwsx8bf4z7d29a5vig8kbhrv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo libX11 libjack2 liblo libsigcxx zita-resampler fftwFloat ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/brummer10/XTuner";
    description = "Tuner for Jack Audio Connection Kit";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
