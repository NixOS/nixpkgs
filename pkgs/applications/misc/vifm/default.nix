{ stdenv, fetchurl
, pkgconfig
, ncurses, libX11
, utillinux, file, which, groff
}:

stdenv.mkDerivation rec {
  pname = "vifm";
  version = "0.10.1";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "0fyhxh7ndjn8fyjhj14ymkr3pjcs3k1xbs43g7xvvq85vdb6y04r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libX11 utillinux file which groff ];

  meta = with stdenv.lib; {
    description = "A vi-like file manager";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    downloadPage = "https://vifm.info/downloads.shtml";
    homepage = https://vifm.info/;
    inherit version;
    updateWalker = true;
  };
}

