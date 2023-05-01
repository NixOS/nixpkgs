{ lib, mkDerivation, fetchurl, qtbase, qtscript, qtwebengine, qmake, zlib, pkg-config, poppler, wrapGAppsHook }:

mkDerivation rec {
  pname = "texmaker";
  version = "5.1.3";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/${pname}-${version}.tar.bz2";
    sha256 = "0qczc2r01vhap11xmqizwbq21ggn4yjrxim8iqjxaq9w1rg2x9dz";
  };

  buildInputs = [ qtbase qtscript poppler zlib qtwebengine ];
  nativeBuildInputs = [ pkg-config poppler qmake wrapGAppsHook ];
  env.NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  qmakeFlags = [
    "DESKTOPDIR=${placeholder "out"}/share/applications"
    "ICONDIR=${placeholder "out"}/share/pixmaps"
    "METAINFODIR=${placeholder "out"}/share/metainfo"
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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
  };
}
