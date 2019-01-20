{ stdenv, fetchurl
, pkgconfig
, ncurses, libX11
, utillinux, file, which, groff
}:

stdenv.mkDerivation rec {
  name = "vifm-${version}";
  version = "0.10";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${version}/vifm-${version}.tar.bz2";
    sha256 = "1f380xcyjnm4xmcdazs6dj064bwddhywvn3mgm36k7r7b2gnjnp0";
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

