{ lib, stdenv, fetchurl, pkg-config, gtk3, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg, perl
, boost, libxslt, goffice, wrapGAppsHook, gnome
}:

stdenv.mkDerivation rec {
  pname = "abiword";
  version = "3.0.5";

  src = fetchurl {
    url = "https://www.abisource.com/downloads/abiword/${version}/source/${pname}-${version}.tar.gz";
    hash = "sha256-ElckfplwUI1tFFbT4zDNGQnEtCsl4PChvDJSbW86IbQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [
    gtk3 librsvg bzip2 fribidi libpng popt
    libgsf enchant wv libjpeg perl boost libxslt goffice gnome.adwaita-icon-theme
  ];

  meta = with lib; {
    description = "Word processing program, similar to Microsoft Word";
    homepage = "https://www.abisource.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ylwghst sna ];
  };
}
