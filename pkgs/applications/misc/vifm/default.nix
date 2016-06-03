{ stdenv, fetchurl
, pkgconfig
, ncurses, libX11
, utillinux, file, which, groff
}:

stdenv.mkDerivation rec {
  name = "vifm-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/vifm/vifm/${name}.tar.bz2";
    sha256 = "0yf3xc4czdrcbvmhq7d4xkck5phrmxwybmnv1zdb56qg56baq64r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libX11 utillinux file which groff ];

  meta = with stdenv.lib; {
    description = "A vi-like file manager";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://vifm.sf.net";
    };
  };
}

