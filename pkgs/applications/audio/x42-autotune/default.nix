{ stdenv, fetchFromGitHub, pkgconfig
, cairo, fftwSinglePrec, libGLU, libjack2, lv2, pango
}:

stdenv.mkDerivation rec {
  pname = "x42-autotune";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "fat1.lv2";
    rev = "v${version}";
    sha256 = "0kz7fr7r3hrzqk9mzd2gdrmd4vdnbhx6n440mishcd9pay5i81aa";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo fftwSinglePrec libGLU libjack2 lv2 pango ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Auto-tuner (aka fat1.lv2) based on Fons Adriaensen's zita-at1";
    homepage = https://x42-plugins.com/x42/x42-autotune;
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
