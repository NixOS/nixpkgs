{ stdenv, fetchurl
, pkgconfig
, ncurses, libX11
, utillinux, file, which, groff
}:

stdenv.mkDerivation rec {
  name = "vifm-${version}";
  version = "0.9";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "1zd72vcgir3g9rhs2iyca13qf5fc0b1f22y20f5gy92c3sfwj45b";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libX11 utillinux file which groff ];

  meta = with stdenv.lib; {
    description = "A vi-like file manager";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "http://vifm.info/downloads.shtml";
    homepage = "http://vifm.info/";
    inherit version;
    updateWalker = true;
  };
}

