{ lib, stdenv, fetchFromGitHub, pkg-config, cairo, glib, libGLU, lv2, pango }:

stdenv.mkDerivation rec {
  pname = "x42-avldrums";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "avldrums.lv2";
    rev = "v${version}";
    hash = "sha256-NNqBZTWjIM97qsXTW/+6T7eOAELi/OwXh4mCYPD/C6I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo glib libGLU lv2 pango ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Drum sample player LV2 plugin dedicated to Glen MacArthur's AVLdrums";
    homepage = "https://x42-plugins.com/x42/x42-avldrums";
    maintainers = with maintainers; [ magnetophon orivej ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
