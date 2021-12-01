{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, autoreconfHook
, gnome2
, gtk2
, glib
, libtifiles2
, libticables2
, libticalcs2
, libticonv
}:

stdenv.mkDerivation rec {
  pname = "gfm";
  version = "1.08";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
    sha256 = "0zq1a9mm54zr18dz2mqh79w1a126xwqz6dcrpjlbd1pnmg01l0q9";
  };

  patches = fetchpatch {
    name = "remove-broken-kde-support.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/remove-broken-kde-support.patch?h=gfm";
    sha256 = "03yc8s2avicmv04f2ygg3r3q8l7kpsc94mhp6clp584kmjpjqag5";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk2
    gnome2.libglade
    glib
    libtifiles2
    libticables2
    libticalcs2
    libticonv
  ];

  NIX_CFLAGS_COMPILE = "-I${libticables2}/include/tilp2";

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "Group File Manager (GFM) allows manipulation of single/group/tigroup files";
    homepage = "http://lpg.ticalc.org/prj_gfm/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ siraben luc65r ];
    platforms = with platforms; linux ++ darwin;
  };
}
