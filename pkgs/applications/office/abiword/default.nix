{stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomeprint,
libgnomeprintui, libgnomecanvas, fribidi, libpng, popt, libgsf,
enchant, wv
}:

stdenv.mkDerivation {
  name = "abiword-2.6.4";
  src = fetchurl {
    url = http://www.abisource.com/downloads/abiword/2.6.4/source/abiword-2.6.4.tar.gz;
    sha256 = "1zp9p2dfrskn7r827ivvii2477ysxkvrsshk79hgw3xhd5mplbad";
  };

  buildInputs = [pkgconfig gtk libglade libgnomeprint libgnomeprintui
                 libgnomecanvas fribidi libpng popt libgsf enchant wv
                ];
}
