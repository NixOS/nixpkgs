{ lib, stdenv, fetchurl, cmake, qtbase, qttools, qtwebengine, qt5compat, zlib, pkg-config, poppler, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "texmaker";
  version = "6.0.0";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${pname}-${version}.tar.bz2";
    hash = "sha256-l3zlgOJcGrbgvD2hA74LQ+v2C4zg0nJzEE/df1hhd/w=";
  };

  buildInputs = [ qtbase poppler zlib qtwebengine qt5compat qttools ];
  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ];

  qmakeFlags = [
    "DESKTOPDIR=${placeholder "out"}/share/applications"
    "ICONDIR=${placeholder "out"}/share/pixmaps"
    "METAINFODIR=${placeholder "out"}/share/metainfo"
  ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      This editor is a full fledged IDE for TeX and
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "http://www.xm1math.net/texmaker/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cfouche markuskowa ];
    mainProgram = "texmaker";
  };
}
