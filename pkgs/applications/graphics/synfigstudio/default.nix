{ stdenv, fetchurl, boost, cairo, gettext, glibmm, gtk, gtkmm
, libsigcxx, libtool, libxmlxx, pango, pkgconfig, imagemagick
, intltool
}:

let
  version = "0.64.1";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.17";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/${name}.tar.gz";
       sha256 = "13kpiswgcpsif9fwcplqr0405aqavqn390cjnivkn3pxv0d2q8iy";
    };
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/synfig-${version}.tar.gz";
       sha256 = "1b4ksxnqbaq4rxlvasmrvk7z4jvjbsg4ns3cns2qcnz64dyvbgda";
    };

    patches = [ ./synfig-cstring.patch ];

    buildInputs = [
      ETL boost cairo gettext glibmm libsigcxx libtool libxmlxx pango
      pkgconfig
    ];

    configureFlags = [ "--with-boost-libdir=${boost}/lib" ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchurl {
       url = "mirror://sourceforge/synfig/${name}.tar.gz";
       sha256 = "0nl6vpsn5dcjd5qhbrmd0j4mr3wddvymkg9414m77cdpz4l8b9v2";
    };

  buildInputs = [
    ETL boost cairo gettext glibmm gtk gtkmm imagemagick intltool
    intltool libsigcxx libtool libxmlxx pkgconfig synfig
  ];

  meta = with stdenv.lib; {
    description = "A 2D animation program";
    homepage = http://www.synfig.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
