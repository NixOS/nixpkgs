{ stdenv, fetchFromGitHub, pkgconfig, cairo, glib, libGLU, lv2, pango }:

stdenv.mkDerivation rec {
  pname = "x42-avldrums";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "avldrums.lv2";
    rev = "v${version}";
    sha256 = "1vwdp3d8qzd493qa99ddya7iql67bbfxmbcl8hk96lxif2lhmyws";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo glib libGLU lv2 pango ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums";
    homepage = "https://x42-plugins.com/x42/x42-avldrums";
    maintainers = with maintainers; [ magnetophon orivej ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
