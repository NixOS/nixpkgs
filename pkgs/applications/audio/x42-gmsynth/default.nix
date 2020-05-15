{ stdenv, fetchFromGitHub, pkgconfig, glib, lv2 }:

stdenv.mkDerivation rec {
  pname = "x42-gmsynth";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "gmsynth.lv2";
    rev = "v${version}";
    sha256 = "08dvdj8r17sfl6l18g2b8abgls2irkbrq5vhrfai01hp2m0rlm34";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib lv2 ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Chris Colins' General User soundfont player LV2 plugin";
    homepage = "https://x42-plugins.com/x42/x42-gmsynth";
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
