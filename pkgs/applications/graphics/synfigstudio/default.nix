{ stdenv, fetchurl, boost, cairo, fontsConf, gettext, glibmm, gtk, gtkmm
, libsigcxx, libtool, libxmlxx, pango, pkgconfig, imagemagick
, intltool
}:

let
  version = "0.64.3";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.17";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/${name}.tar.gz";
       sha256 = "0rb9czkgan41q6xlck97kh77g176vjm1wnq620sqky7k2hiahr3s";
    };
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchurl {
       url = "mirror://sourceforge/synfig/synfig-${version}.tar.gz";
       sha256 = "0p4wqjidb4k3viahck4wzbh777f5ifpivn4vxhxs5fbq8nsvqksh";
    };

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.lib}/lib"
    ];

    patches = [ ./synfig-cstring.patch ];

    buildInputs = [
      ETL boost cairo gettext glibmm libsigcxx libtool libxmlxx pango
      pkgconfig
    ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/synfig/${name}.tar.gz";
    sha256 = "1li3ac8qvg25h9fgym0zywnq5bg3sgbv162xs4c6pwksn75i6gsv";
  };

  buildInputs = [
    ETL boost cairo gettext glibmm gtk gtkmm imagemagick intltool
    intltool libsigcxx libtool libxmlxx pkgconfig synfig
  ];

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.lib}/lib"
  ];

  preBuild = ''
    export FONTCONFIG_FILE=${fontsConf}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D animation program";
    homepage = http://www.synfig.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
