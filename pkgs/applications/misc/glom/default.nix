{ lib, stdenv
, fetchurl
, pkg-config
, autoconf
, automake
, libtool
, mm-common
, intltool
, itstool
, doxygen
, graphviz
, makeFontsConf
, freefont_ttf
, boost
, libxmlxx3
, libxslt
, libgdamm
, libarchive
, libepc
, python3
, ncurses
, glibmm
, gtk3
, openssl
, gtkmm3
, goocanvasmm2
, evince
, isocodes
, gtksourceview
, gtksourceviewmm
, postgresql_11
, gobject-introspection
, yelp-tools
, wrapGAppsHook
}:

let
  gda = libgdamm.override {
    mysqlSupport = true;
    postgresSupport = true;
  };
  python = python3.withPackages (pkgs: with pkgs; [ pygobject3 ]);
  sphinx-build = python3.pkgs.sphinx.overrideAttrs (super: {
    postFixup = super.postFixup or "" + ''
      # Do not propagate Python
      rm $out/nix-support/propagated-build-inputs
    '';
  });
  boost_python = boost.override { enablePython = true; inherit python; };
in stdenv.mkDerivation rec {
  pname = "glom";
  version = "1.32.0";

  outputs = [ "out" "lib" "dev" "doc" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wcd4kd3crwqjv0jfp73jkyyf5ws8mvykg37kqxmcb58piz21gsk";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
    mm-common
    intltool
    yelp-tools
    itstool
    doxygen
    graphviz
    sphinx-build
    wrapGAppsHook
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    boost_python
    glibmm
    gtk3
    openssl
    libxmlxx3
    libxslt
    gda
    libarchive
    libepc
    python
    ncurses # for python
    gtkmm3
    goocanvasmm2
    evince
    isocodes
    python3.pkgs.pygobject3
    gtksourceview
    gtksourceviewmm
    postgresql_11 # for pg_config
  ];

  enableParallelBuilding = true;

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--with-boost-python=boost_python${lib.versions.major python3.version}${lib.versions.minor python3.version}"
  ];

  makeFlags = [
    "libdocdir=${placeholder "doc"}/share/doc/$(book_name)"
    "devhelpdir=${placeholder "devdoc"}/share/devhelp/books/$(book_name)"
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "${placeholder "out"}/${python3.sitePackages}"
      --set PYTHONHOME "${python}"
    )
  '';

  meta = with lib; {
    description = "An easy-to-use database designer and user interface";
    homepage = "http://www.glom.org/";
    license = [ licenses.lgpl2 licenses.gpl2 ];
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
