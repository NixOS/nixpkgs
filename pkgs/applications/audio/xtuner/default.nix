{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Fix build against glibc-2.38.
    (fetchpatch {
      name = "glibc-2.38.patch";
      url = "https://github.com/brummer10/libxputty/commit/7eb70bf3f7bce0af9e1919d6c875cdb8efca734e.patch";
      hash = "sha256-VspR0KJjBt4WOrnlo7rHw1oAYM1d2RSz6JhuAEfsO3M=";
      stripLen = 1;
      extraPrefix = "libxputty/";
    })
  ];

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
    mainProgram = "xtuner";
  };
}
