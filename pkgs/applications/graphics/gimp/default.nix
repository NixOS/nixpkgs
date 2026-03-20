{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  babl,
  bash-completion,
  cfitsio,
  gegl,
  gtk3,
  glib,
  gdk-pixbuf,
  graphviz,
  isocodes,
  pango,
  cairo,
  libarchive,
  luajit,
  freetype,
  fontconfig,
  lcms,
  libpng,
  libiff,
  libilbm,
  libjpeg,
  libjxl,
  poppler,
  poppler_data,
  libtiff,
  libmng,
  librsvg,
  libwmf,
  zlib,
  xz,
  libzip,
  ghostscript,
  aalib,
  shared-mime-info,
  python3,
  libexif,
  gettext,
  glibcLocales,
  wrapGAppsHook3,
  libxslt,
  gobject-introspection,
  vala,
  gi-docgen,
  perl,
  appstream,
  desktop-file-utils,
  libxpm,
  libxmu,
  glib-networking,
  json-glib,
  libmypaint,
  llvmPackages,
  gexiv2,
  harfbuzz,
  makeFontsConf,
  mypaint-brushes1,
  libwebp,
  libheif,
  gjs,
  libgudev,
  openexr,
  xvfb-run,
  dbus,
  adwaita-icon-theme,
  alsa-lib,
  desktopToDarwinBundle,
  fetchpatch,
  qoi,
}:

let
  python = python3.withPackages (
    pp: with pp; [
      pygobject3
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gimp";
  version = "3.0.8";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  src = fetchurl {
    url = "https://download.gimp.org/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    hash = "sha256-/rSYrMAbJoJ8/x/5Wqj7gs3Wpg16v3c8/NGavq/KM4Y=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (replaceVars ./remove-cc-reference.patch {
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    # TODO: This now only appears to be used on Windows.
    (replaceVars ./hardcode-plugin-interpreters.patch {
      python_interpreter = python.interpreter;
      PYTHON_EXE = null;
    })

    # D-Bus configuration is not available in the build sandbox
    # so we need to pick up the one from the package.
    (replaceVars ./tests-dbus-conf.patch {
      session_conf = "${dbus.out}/share/dbus-1/session.conf";
    })

    # Allow calling tests from other directories.
    # Required for the next patch.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gimp/-/commit/fd58ab3bee7a79cb0a7870c6858f3b64c84a7917.patch";
      hash = "sha256-fpysKWwt5rilqp7ukdWx7kutkDquL/6YhYjR1zQfu/Q=";
    })

    # Do not go through ui for save-and-export test.
    # https://gitlab.gnome.org/GNOME/gimp/-/issues/15763
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gimp/-/commit/608ad0a528b5b31101c021d96aeb95558d207497.patch";
      hash = "sha256-0oA5u+uAT0l3WT90fy0RGOR8xy/fGIHevBb69oUzfGs=";
      excludes = [
        # Other changes would prevent deletion, removing it from build is sufficient.
        "app/tests/test-save-and-export.c"
      ];
    })

    # Disable broken UI tests.
    # https://gitlab.gnome.org/GNOME/gimp/-/issues/15763
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gimp/-/commit/c34fe3e94f1019eafcb38edf1c07bff12a57431e.patch";
      hash = "sha256-yVauEpoGEOIfCXnGnWMGWjXbIDizDhJ3hipeCy3XSBM=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glibcLocales
    wrapGAppsHook3
    libxslt # for xsltproc
    gobject-introspection
    perl
    vala

    # for docs
    gi-docgen

    # for tests
    desktop-file-utils
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    xvfb-run
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    appstream # for library
    babl
    bash-completion
    cfitsio
    gegl
    gtk3
    glib
    gdk-pixbuf
    pango
    cairo
    libarchive
    gexiv2
    harfbuzz
    isocodes
    freetype
    fontconfig
    lcms
    libpng
    libiff
    libilbm
    libjpeg
    libjxl
    poppler
    poppler_data
    libtiff
    openexr
    libmng
    librsvg
    libwmf
    zlib
    xz
    libzip
    ghostscript
    aalib
    shared-mime-info
    json-glib
    libwebp
    libheif
    python
    libexif
    libxpm
    libxmu
    glib-networking
    libmypaint
    mypaint-brushes1
    qoi

    # New file dialogue crashes with “Icon 'image-missing' not present in theme Symbolic” without an icon theme.
    adwaita-icon-theme

    # for Lua plug-ins
    (luajit.withPackages (pp: [
      pp.lgi
    ]))
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib

    # for JavaScript plug-ins
    gjs
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libgudev
  ];

  propagatedBuildInputs = [
    # needed by gimp-3.0.pc
    gegl
    cairo
    pango
    gexiv2
  ];

  mesonFlags = [
    "-Dbug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
    "-Dicc-directory=/run/current-system/sw/share/color/icc"
    "-Dcheck-update=no"
    (lib.mesonEnable "gudev" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "headless-tests" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "linux-input" stdenv.hostPlatform.isLinux)
    # Not very important to do downstream, save a dependency.
    "-Dappdata-test=disabled"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Dalsa=disabled"
    "-Djavascript=disabled"
  ];

  doCheck = true;

  env = {
    # The check runs before glib-networking is registered
    GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";

    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DGDK_OSX_BIG_SUR=16";

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";

    # Silence fontconfig warnings about missing config during tests
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ ];
    };
  };

  postPatch = ''
    patchShebangs tools/gimp-mkenums

    # GIMP is executed at build time so we need to fix this.
    # TODO: Look into if we can fix the interp thing.
    chmod +x plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py
    patchShebangs \
      plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py

    # Use Python from environment not from Meson.
    # https://gitlab.gnome.org/GNOME/gimp/-/merge_requests/2607
    substituteInPlace meson.build \
      --replace-fail "import('python').find_installation()" "import('python').find_installation('python3')"

    # Broken test
    # https://github.com/NixOS/nixpkgs/pull/484971#issuecomment-3846759517
    substituteInPlace app/tests/meson.build \
      --replace-fail "{${"\n"}    'name': 'save-and-export',${"\n"}  }${"\n"}" ""
  '';

  preBuild =
    let
      librarySuffix =
        if stdenv.hostPlatform.extensions.library == ".so" then
          "3.0.so.0"
        else if stdenv.hostPlatform.extensions.library == ".dylib" then
          "3.0.0.dylib"
        else
          throw "Unsupported library extension ‘${stdenv.hostPlatform.extensions.library}’";
    in
    ''
      # Our gobject-introspection patches make the shared library paths absolute
      # in the GIR files. When running GIMP in build or check phase, it will try
      # to use plug-ins, which import GIMP introspection files which will try
      # to load the GIMP libraries which will not be installed yet.
      # So we need to replace the absolute path with a local one.
      # We are using a symlink that will be overridden during installation.
      mkdir -p "$out/lib"
      ln -s "$PWD/libgimp/libgimp-${librarySuffix}" \
        "$PWD/libgimpbase/libgimpbase-${librarySuffix}" \
        "$PWD/libgimpcolor/libgimpcolor-${librarySuffix}" \
        "$PWD/libgimpconfig/libgimpconfig-${librarySuffix}" \
        "$PWD/libgimpmath/libgimpmath-${librarySuffix}" \
        "$PWD/libgimpmodule/libgimpmodule-${librarySuffix}" \
        "$out/lib/"
    '';

  preCheck = ''
    # Avoid “Error retrieving accessibility bus address”
    export NO_AT_BRIDGE=1
    # Fix storing recent file list in tests
    export HOME="$TMPDIR"
    export XDG_DATA_DIRS="${glib.getSchemaDataDirPath gtk3}:${adwaita-icon-theme}/share:$XDG_DATA_DIRS"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        # for dot for gegl:introspect (Debug » Show Image Graph, hidden by default on stable release)
        graphviz
        # for gimp-script-fu-interpreter-3.0 invoked by shebang of some plug-ins
        "$out"
      ]
    }")
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "${lib.versions.major finalAttrs.version}.0";
    targetLibDir = "lib/gimp/${finalAttrs.passthru.majorVersion}";
    targetDataDir = "share/gimp/${finalAttrs.passthru.majorVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk3;
  };

  meta = {
    description = "GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with lib.maintainers; [ jtojnar ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gimp";
  };
})
