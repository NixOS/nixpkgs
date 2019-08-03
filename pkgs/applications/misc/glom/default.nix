{ stdenv
, fetchFromGitLab
, pkgconfig
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
, gtksourceviewmm4
, postgresql
, gnome3
, gobject-introspection
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
  version = "unstable-2018-12-16";

  outputs = [ "out" "lib" "dev" "doc" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "fa5ff04f209f35bf3e97bc1c3eb1d1138d6172ce";
    sha256 = "145hnk96xa4v35i3a3mbf3fnx4nlk8cksc0qhm7nrh8cnnrbdfgn";
  };

  nativeBuildInputs = [
    pkgconfig
    autoconf
    automake
    libtool
    mm-common
    intltool
    gnome3.yelp-tools
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
    gtksourceviewmm4
    postgresql # for pg_config
  ];

  enableParallelBuilding = true;

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--with-boost-python=boost_python${stdenv.lib.versions.major python3.version}${stdenv.lib.versions.minor python3.version}"
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

  meta = with stdenv.lib; {
    description = "An easy-to-use database designer and user interface";
    homepage = http://www.glom.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
