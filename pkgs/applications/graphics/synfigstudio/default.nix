{ stdenv, fetchurl, boost, cairo, fontsConf, gettext, glibmm, gtk, gtkmm
, libsigcxx, libtool, libxmlxx, pango, pkgconfig, imagemagick
, intltool
}:

let
  version = "0.64.2";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.17";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/${name}.tar.gz";
       sha256 = "1i2m31y5hdwr365z3zmfh5p3zm4ga4l4yqrl1qrmjryqqzkw200l";
    };
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/synfig-${version}.tar.gz";
       sha256 = "04mx321z929ngl65hfc1hv5jw37wqbh8y2avmpvajagvn6lp3zdl";
    };

    patches = [ ./synfig-cstring.patch ];

    buildInputs = [
      ETL boost boost.lib cairo gettext glibmm libsigcxx libtool libxmlxx pango
      pkgconfig
    ];

    configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchurl {
       url = "mirror://sourceforge/synfig/${name}.tar.gz";
       sha256 = "13hw4z6yx70g4mnjmvmxkk7b1qzlwmqjhxflq5dd6cqdsmfw9mc7";
    };

  buildInputs = [
    ETL boost cairo fontsConf gettext glibmm gtk gtkmm imagemagick intltool
    intltool libsigcxx libtool libxmlxx pkgconfig synfig
  ];

  preBuild = ''
    export FONTCONFIG_FILE=${fontsConf}
  '';

  meta = with stdenv.lib; {
    description = "A 2D animation program";
    homepage = http://www.synfig.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
