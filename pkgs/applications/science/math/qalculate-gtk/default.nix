{ stdenv, fetchurl, intltool, autoreconfHook, pkgconfig, libqalculate, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "qalculate-gtk-${version}";
  version = "0.9.9";

  src = fetchurl {
    url = "https://github.com/Qalculate/qalculate-gtk/archive/v${version}.tar.gz";
    sha256 = "0v9ibycilygmi9zzi7cxif7si56c85lfzdvbqnbf32whg8ydqqkg";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [ libqalculate gtk3 ];

  meta = with stdenv.lib; {
    description = "The ultimate desktop calculator";
    homepage = http://qalculate.github.io;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
