{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  fetchpatch,
  substituteAll,
  meson,
  ninja,
  pkg-config,
  babl,
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
  libjpeg,
  libjxl,
  poppler,
  poppler_data,
  libtiff,
  libmng,
  librsvg,
  libwmf,
  zlib,
  libzip,
  ghostscript,
  aalib,
  shared-mime-info,
  python3,
  libexif,
  gettext,
  wrapGAppsHook3,
  libxslt,
  gobject-introspection,
  vala,
  gi-docgen,
  perl,
  appstream-glib,
  desktop-file-utils,
  xorg,
  glib-networking,
  json-glib,
  libmypaint,
  gexiv2,
  harfbuzz,
  mypaint-brushes1,
  libwebp,
  libheif,
  gjs,
  libgudev,
  openexr,
  xvfb-run,
  dbus,
  adwaita-icon-theme,
  hicolor-icon-theme,
  alsa-lib,
  desktopToDarwinBundle,
  AppKit,
  Cocoa,
  unstableGitUpdater,
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
  version = "3.0.0-RC2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://download.gimp.org/gimp/v${lib.versions.majorMinor finalAttrs.version}/gimp-${finalAttrs.version}.tar.xz";
    hash = "sha256-9NL5bfGAzlVD+LKzVwe5vxFFnwD3Jspz2i9AbWhtnbc=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (substituteAll {
      src = ./remove-cc-reference.patch;
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    # TODO: This now only appears to be used on Windows.
    (substituteAll {
      src = ./hardcode-plugin-interpreters.patch;
      python_interpreter = python.interpreter;
    })

    # D-Bus configuration is not available in the build sandbox
    # so we need to pick up the one from the package.
    (substituteAll {
      src = ./tests-dbus-conf.patch;
      session_conf = "${dbus.out}/share/dbus-1/session.conf";
    })

    # Fix pkg-config file.
    # https://gitlab.gnome.org/GNOME/gimp/-/merge_requests/2037
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gimp/-/commit/a18e1806dbc9b180aefabb2c0fae43493f1ef14a.patch";
      hash = "sha256-BUrPm9lB/aiybB2Sd3TKlJ+59ITMZlNUBXJP5ZdLQ44=";
    })
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      gettext
      wrapGAppsHook3
      libxslt # for xsltproc
      gobject-introspection
      perl
      vala

      # for docs
      gi-docgen

      # for tests
      desktop-file-utils
      dbus
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      xvfb-run
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      desktopToDarwinBundle
    ];

  buildInputs =
    [
      appstream-glib # for library
      babl
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
      libzip
      ghostscript
      aalib
      shared-mime-info
      json-glib
      libwebp
      libheif
      python
      libexif
      xorg.libXpm
      xorg.libXmu
      glib-networking
      libmypaint
      mypaint-brushes1

      # New file dialogue crashes with “Icon 'image-missing' not present in theme Symbolic” without an icon theme.
      adwaita-icon-theme

      # for Lua plug-ins
      (luajit.withPackages (pp: [
        pp.lgi
      ]))
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      alsa-lib

      # for JavaScript plug-ins
      gjs
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      Cocoa
    ]
    ++ lib.optionals stdenv.isLinux [
      libgudev
    ];

  propagatedBuildInputs = [
    # needed by gimp-3.0.pc
    gegl
    cairo
    pango
    gexiv2
  ];

  mesonFlags =
    [
      "-Dbug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
      "-Dicc-directory=/run/current-system/sw/share/color/icc"
      "-Dcheck-update=no"
      # Requires neweer appstreamcli and not necessary
      "-Dappdata-test=disabled"
      # Not yet packaged.
      "-Dilbm=disabled"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-Dalsa=disabled"
      "-Djavascript=disabled"
    ];

  # on Linux, unable to find icons
  doCheck = true;

  env = {
    # The check runs before glib-networking is registered
    GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";

    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DGDK_OSX_BIG_SUR=16";

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";
  };

  postPatch = ''
    patchShebangs \
      app/tests/create_test_env.sh \
      tools/gimp-mkenums

    # GIMP is executed at build time so we need to fix this.
    # TODO: Look into if we can fix the interp thing.
    chmod +x plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py
    patchShebangs \
      plug-ins/python/{colorxhtml,file-openraster,foggify,gradients-save-as-css,histogram-export,palette-offset,palette-sort,palette-to-gradient,python-eval,spyro-plus}.py
  '';

  preBuild = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running GIMP in build or check phase, it will try
    # to use plug-ins, which import GIMP introspection files which will try
    # to load the GIMP libraries which will not be installed yet.
    # So we need to replace the absolute path with a local one.
    # We are using a symlink that will be overridden during installation.
    mkdir -p "$out/lib"
    ln -s "$PWD/libgimp/libgimp-3.0.so.0" "$out/lib/libgimp-3.0.so.0"
    ln -s "$PWD/libgimpbase/libgimpbase-3.0.so.0" "$out/lib/libgimpbase-3.0.so.0"
    ln -s "$PWD/libgimpcolor/libgimpcolor-3.0.so.0" "$out/lib/libgimpcolor-3.0.so.0"
    ln -s "$PWD/libgimpconfig/libgimpconfig-3.0.so.0" "$out/lib/libgimpconfig-3.0.so.0"
    ln -s "$PWD/libgimpmath/libgimpmath-3.0.so.0" "$out/lib/libgimpmath-3.0.so.0"
    ln -s "$PWD/libgimpmodule/libgimpmodule-3.0.so.0" "$out/lib/libgimpmodule-3.0.so.0"
  '';

  preCheck = ''
    # Avoid “Error retrieving accessibility bus address”
    export NO_AT_BRIDGE=1
    # Fix storing recent file list in tests
    export HOME="$TMPDIR"
    export XDG_DATA_DIRS="${glib.getSchemaDataDirPath gtk3}:${adwaita-icon-theme}/share:$XDG_DATA_DIRS"
  '';

  checkPhase = ''
    runHook preCheck

    meson test --timeout-multiplier 4 --print-errorlogs

    runHook postCheck
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${
      lib.makeBinPath [
        # for dot for gegl:introspect (Debug » Show Image Graph, hidden by default on stable release)
        graphviz
      ]
    }:$out/bin")
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "3.0";
    targetLibDir = "lib/gimp/${finalAttrs.passthru.majorVersion}";
    targetDataDir = "share/gimp/${finalAttrs.passthru.majorVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk3;
  };

  meta = with lib; {
    description = "GNU Image Manipulation Program";
    homepage = "https://www.gimp.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "gimp";
  };
})
