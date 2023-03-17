{
  stdenv,
  lib,
  fetchFromGitLab,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  babl,
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
  alsa-lib,
  desktopToDarwinBundle,
  AppKit,
  Cocoa,
  gtk-mac-integration-gtk3,
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
  version = "2.99.14-unstable-2023-03-17";

  outputs = [
    "out"
    "dev"
  ];

  # We should not use fetchFromGitLab because the build system
  # will complain and mark the build as unsupported when it cannot find
  # .git directory but downloading the whole repo is jus too much.
  src = fetchFromGitLab rec {
    name = "gimp-dev-${rev}"; # to make sure the hash is updated
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gimp";
    rev = "ad7a2e53eb72ef471566fa2d0ce9faeec929fbcf";
    hash = "sha256-IJMUJc817EDWIRqqkCuwAcSw7gcgCkXxPan5fEq1AO0=";
  };

  patches = [
    # to remove compiler from the runtime closure, reference was retained via
    # gimp --version --verbose output
    (replaceVars ./remove-cc-reference.patch {
      cc_version = stdenv.cc.cc.name;
    })

    # Use absolute paths instead of relying on PATH
    # to make sure plug-ins are loaded by the correct interpreter.
    (replaceVars ./hardcode-plugin-interpreters.patch {
      python_interpreter = python.interpreter;
      PYTHON_PATH = null;
    })

    # D-Bus configuration is not available in the build sandbox
    # so we need to pick up the one from the package.
    (replaceVars ./tests-dbus-conf.patch {
      session_conf = "${dbus.out}/share/dbus-1/session.conf";
    })

    # Since we pass absolute datadirs to Meson, the path is resolved incorrectly.
    # What is more, even the assumption that iso-codes have the same datadir
    # subdirectory as GIMP is incorrect. Though, there is not a way to obtain
    # the correct directory at the moment. There is a MR against isocodes to fix that:
    # https://salsa.debian.org/iso-codes-team/iso-codes/merge_requests/11
    ./fix-isocodes-paths.patch
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

  buildInputs =
    [
      appstream-glib # for library
      babl
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
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib

      # for JavaScript plug-ins
      gjs
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      Cocoa
      gtk-mac-integration-gtk3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libgudev
    ];

  propagatedBuildInputs = [
    # needed by gimp-3.0.pc
    gegl
  ];

  mesonFlags =
    [
      "-Dbug-report-url=https://github.com/NixOS/nixpkgs/issues/new"
      "-Dicc-directory=/run/current-system/sw/share/color/icc"
      "-Dcheck-update=no"
      (lib.mesonEnable "gudev" stdenv.hostPlatform.isLinux)
      (lib.mesonEnable "headless-tests" stdenv.hostPlatform.isLinux)
      (lib.mesonEnable "linux-input" stdenv.hostPlatform.isLinux)
      # Not very important to do downstream, save a dependency.
      "-Dappdata-test=disabled"
      # Incompatible with version in nixpkgs
      "-Djpeg-xl=disabled"
      # Broken references
      "-Dgi-docgen=disabled"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-Dalsa=disabled"
      "-Djavascript=false"
    ];

  doCheck = true;

  env = {
    # The check runs before glib-networking is registered
    GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";

    NIX_CFLAGS_COMPILE = toString (
      [ ]
      ++ lib.optionals stdenv.cc.isGNU [ "-Wno-error=incompatible-pointer-types" ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DGDK_OSX_BIG_SUR=16" ]
    );

    # Check if librsvg was built with --disable-pixbuf-loader.
    PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${librsvg}/${gdk-pixbuf.moduleDir}";
  };

  postPatch = ''
    patchShebangs \
      app/tests/create_test_env.sh \
      tools/gimp-mkenums

    # Bypass the need for downloading git archive.
    substitute app/git-version.h.in git-version.h \
      --subst-var-by GIMP_GIT_VERSION "GIMP_2.99.?-g${builtins.substring 0 10 finalAttrs.src.rev}" \
      --subst-var-by GIMP_GIT_VERSION_ABBREV "${builtins.substring 0 10 finalAttrs.src.rev}" \
      --subst-var-by GIMP_GIT_LAST_COMMIT_YEAR "${builtins.head (builtins.match ".+\-unstable-([0-9]{4})-[0-9]{2}-[0-9]{2}" finalAttrs.version)}"
  '';

  preCheck = ''
    # Avoid “Error retrieving accessibility bus address”
    export NO_AT_BRIDGE=1
    # Fix storing recent file list in tests
    export HOME="$TMPDIR"
    export XDG_DATA_DIRS="${glib.getSchemaDataDirPath gtk3}:$XDG_DATA_DIRS"
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

  passthru = {
    # The declarations for `gimp-with-plugins` wrapper,
    # used for determining plug-in installation paths
    majorVersion = "2.99";
    targetLibDir = "lib/gimp/${finalAttrs.passthru.majorVersion}";
    targetDataDir = "share/gimp/${finalAttrs.passthru.majorVersion}";
    targetPluginDir = "${finalAttrs.passthru.targetLibDir}/plug-ins";
    targetScriptDir = "${finalAttrs.passthru.targetDataDir}/scripts";

    # probably its a good idea to use the same gtk in plugins ?
    gtk = gtk3;

    updateScript = unstableGitUpdater {
      stableVersion = true;
      tagPrefix = "GIMP_";
      tagConverter = "sed s/_/./g";
    };
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
