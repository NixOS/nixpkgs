{ stdenv, fetchurl
, pkgconfig
, ncurses, libX11
, utillinux, file, which, groff
}:

stdenv.mkDerivation rec {
  name = "vifm-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "1cz7vjjmghgdxd1lvsdwv85gvx4kz8idq14qijpwkpfrf2va9f98";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libX11 utillinux file which groff ];

  meta = with stdenv.lib; {
    description = "A vi-like file manager";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "https://vifm.info/downloads.shtml";
    homepage = https://vifm.info/;
    inherit version;
    updateWalker = true;
  };
}

