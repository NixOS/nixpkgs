{ stdenv, fetchurl, boost, cairo, fontsConf, gettext, glibmm, gtk3, gtkmm3
, libjack2, libsigcxx, libtool, libxmlxx, makeWrapper, mlt-qt5, pango, pkgconfig
, imagemagick, intltool
}:

let
  version = "1.0.1";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.19";

    src = fetchurl {
       url = "http://download.tuxfamily.org/synfig/releases/${version}/${name}.tar.gz";
       sha256 = "1zmqv2fa5zxprza3wbhk5mxjk7491jqshxxai92s7fdiza0nhs91";
    };
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchurl {
       url = "http://download.tuxfamily.org/synfig/releases/${version}/${name}.tar.gz";
       sha256 = "0l1f2xwmzds32g46fqwsq7j5qlnfps6944chbv14d3ynzgyyp1i3";
    };

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.lib}/lib"
    ];

    buildInputs = [
      ETL boost cairo gettext glibmm mlt-qt5 libsigcxx libtool libxmlxx pango
      pkgconfig
    ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchurl {
    url = "http://download.tuxfamily.org/synfig/releases/${version}/${name}.tar.gz";
    sha256 = "0jfa946rfh0dbagp18zknlj9ffrd4h45xcy2dh2vlhn6jdm08yfi";
  };

  buildInputs = [
    ETL boost cairo gettext glibmm gtk3 gtkmm3 imagemagick intltool
    libjack2 libsigcxx libtool libxmlxx makeWrapper mlt-qt5 pkgconfig
    synfig
  ];

  postInstall = ''
    wrapProgram "$out/bin/synfigstudio" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
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
