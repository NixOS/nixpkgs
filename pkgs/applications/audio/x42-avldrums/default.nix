{ lib, stdenv, fetchFromGitHub, pkg-config, cairo, glib, libGLU, lv2, pango }:

stdenv.mkDerivation rec {
  pname = "x42-avldrums";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "avldrums.lv2";
    rev = "v${version}";
    sha256 = "sha256-L9rLSHHQIM6PqZ397TIxR6O1N9GKAQtDfWCofV5R85E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo glib libGLU lv2 pango ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums";
    homepage = "https://x42-plugins.com/x42/x42-avldrums";
    maintainers = with maintainers; [ magnetophon orivej ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
