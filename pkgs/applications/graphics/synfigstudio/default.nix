{ stdenv, fetchFromGitHub, boost, cairo, fontsConf, gettext, glibmm, gtk3, gtkmm3
, libjack2, libsigcxx, libtool, libxmlxx, makeWrapper, mlt-qt5, pango, pkgconfig
, imagemagick, intltool, autoreconfHook, which
}:

let
  version = "1.0.2";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.19";

    src = fetchFromGitHub {
       repo   = "synfig";
       owner  = "synfig";
       rev    = version;
       sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
    };

    postUnpack = "sourceRoot=\${sourceRoot}/ETL/";

    buildInputs = [ autoreconfHook ];
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchFromGitHub {
       repo   = "synfig";
       owner  = "synfig";
       rev    = version;
       sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
    };

    postUnpack = "sourceRoot=\${sourceRoot}/synfig-core/";

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ];

    buildInputs = [
      ETL boost cairo gettext glibmm mlt-qt5 libsigcxx libxmlxx pango
      pkgconfig autoreconfHook
    ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchFromGitHub {
     repo   = "synfig";
     owner  = "synfig";
     rev    = version;
     sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/synfig-studio/";

  preConfigure = "./bootstrap.sh";

  buildInputs = [
    ETL boost cairo gettext glibmm gtk3 gtkmm3 imagemagick intltool
    libjack2 libsigcxx libxmlxx makeWrapper mlt-qt5 pkgconfig
    synfig autoreconfHook which
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
