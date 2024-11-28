{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoconf,
  automake,
  libtool,
  mm-common,
  intltool,
  itstool,
  doxygen,
  graphviz,
  makeFontsConf,
  freefont_ttf,
  boost,
  libxmlxx3,
  libxslt,
  libgdamm,
  libarchive,
  libepc,
  python311,
  python3,
  ncurses,
  glibmm,
  gtk3,
  openssl,
  gtkmm3,
  goocanvasmm2,
  evince,
  isocodes,
  gtksourceview,
  gtksourceviewmm,
  postgresql_15,
  gobject-introspection,
  yelp-tools,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glom";
  version = "1.32.0";

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/glom/${lib.versions.majorMinor finalAttrs.version}/glom-${finalAttrs.version}.tar.xz";
    hash = "sha256-U78gfryoLFY7nme86XdFmhfn/ZTjXCfBlphnNtokjfE=";
  };

  gda = libgdamm.override {
    mysqlSupport = true;
    postgresSupport = true;
  };

  python = python311.withPackages (
    pkgs: with pkgs; [
      pygobject3
      distutils
    ]
  );

  python_boost = python311.withPackages (pkgs: with pkgs; [ pygobject3 ]);

  sphinx-build = python311.pkgs.sphinx.overrideAttrs (super: {
    postFixup =
      super.postFixup or ""
      + ''
        # Do not propagate Python
        rm $out/nix-support/propagated-build-inputs
      '';
  });

  boost_python = boost.override {
    enablePython = true;
    python = finalAttrs.python_boost;
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
    mm-common
    intltool
    (yelp-tools.override {
      python3 = python311;
    })
    itstool
    doxygen
    graphviz
    finalAttrs.sphinx-build
    wrapGAppsHook3
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    finalAttrs.boost_python
    glibmm
    gtk3
    openssl
    libxmlxx3
    libxslt
    python311.pkgs.pygobject3
    finalAttrs.gda
    libarchive
    libepc
    finalAttrs.python
    ncurses # for python
    gtkmm3
    goocanvasmm2
    evince
    isocodes
    gtksourceview
    gtksourceviewmm
    postgresql_15 # for postgresql utils
  ];

  enableParallelBuilding = true;

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--with-boost-python=boost_python${lib.versions.major python311.version}${lib.versions.minor python311.version}"
    "--with-postgres-utils=${lib.getBin postgresql_15}/bin"
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
      --prefix PYTHONPATH : "${placeholder "out"}/${python311.sitePackages}"
      --set PYTHONHOME "${finalAttrs.python}"
    )
  '';

  meta = {
    description = "Easy-to-use database designer and user interface";
    license = with lib.licenses; [
      lgpl2
      gpl2
    ];
    homepage = "https://gitlab.gnome.org/Archive/glom";
    maintainers =
      lib.teams.gnome.members
      ++ (with lib.maintainers; [
        bot-wxt1221
      ]);
    platforms = lib.platforms.linux;
  };
})
