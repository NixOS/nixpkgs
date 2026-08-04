{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  fetchpatch,
  meson,
  ninja,
  wrapGAppsHook3,
  breakpointHook,
  gdb,
  gobject-introspection,
  gettext,
  yelp-tools,
  itstool,
  python313,
  gtk3,
  gnome,
  replaceVars,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  xkbcomp,
  glib,
  procps,
  gsettings-desktop-schemas,
  speechd-minimal,
  brltty,
  libsegfault,
  liblouis,
  gst_all_1,
  vte,
  xvfb,
  less,
  nano,
  vim,
  ncurses,
  glibcLocales,
  makeFontsConf,
  dejavu_fonts,
}:

python313.pkgs.buildPythonApplication (finalAttrs: {
  pname = "orca";
  version = "50.2";

  pyproject = false;

  src = /home/jtojnar/Projects/orca;

  patches = [
    (replaceVars ./fix-paths.patch {
      pgrep = "${procps}/bin/pgrep";
      xkbcomp = "${xkbcomp}/bin/xkbcomp";
      at_spi2_core = at-spi2-core;
      prefix = null;
    })
  ];

  # needed for cross-compilation
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    # cross-compilation support requires the host environment's build time
    # to make the following buildPackages available.
    buildPackages.gtk3
    buildPackages.python313
    buildPackages.python313Packages.pygobject3
    meson
    ninja
    wrapGAppsHook3
    breakpointHook
    gdb
    pkg-config
    gettext
    yelp-tools
    itstool
    gobject-introspection
  ];

  pythonPath = with python313.pkgs; [
    dasbus
    pygobject3
    pyxdg
    brltty
    liblouis
    psutil
    speechd-minimal
    gst-python
    setproctitle
    # (at-spi2-core.override { python3 = python313; })
  ];

  strictDeps = false;

  buildInputs = [
    python313
    gtk3
    # at-spi2-atk
    # at-spi2-core
    dbus
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  nativeCheckInputs = with python313.pkgs; [
    pytest
    dbus
    xvfb
    less
    nano
    vim
    ncurses # For clear
  ];

  checkInputs = with python313.pkgs; [
    vte
    pytest-mock
  ];

  mesonFlags = [
    "-Dmathcat=false"
  ];

  mesonCheckFlags = [
    "-v"
  ];

  # Help GI find typelibs during Meson's configure step in cross builds
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export GI_TYPELIB_PATH=${buildPackages.gtk3}/lib/girepository-1.0''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}
  '';

  preCheck = ''
    export LD_PRELOAD=${libsegfault}/lib/libsegfault.so
    export NIX_DEBUG_INFO_DIRS=${glib.debug}/lib/debug:${gtk3.debug}/lib/debug:${at-spi2-core.debug}/lib/debug:${python313.pkgs.pygobject3.debug}/lib/debug
    export SEGFAULT_SIGNALS=all
    export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
    # Silence fontconfig warnings about missing config during tests
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [
      # Tests require DejaVu Sans Mono
      dejavu_fonts
    ]; }}
    export XDG_CACHE_HOME=$(mktemp -d)
    echo PPPPPPPPPPPPPPPPPPPPPPP=$PYTHONPATH
  '';

  # `buildPythonPackage` uses `installCheckPhase` and leaves `checkPhase`
  # empty. It renames `doCheck` from its arguments, but not `checkPhase`.
  # See: https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "mesonCheckPhase";

  dontWrapGApps = true; # Prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    substituteInPlace $out/lib/systemd/user/orca.service --replace-fail ExecStart=orca ExecStart=$out/bin/orca
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "orca";
    };
  };

  meta = {
    homepage = "https://orca.gnome.org/";
    changelog = "https://gitlab.gnome.org/GNOME/orca/-/blob/main/NEWS";
    description = "Screen reader";
    mainProgram = "orca";
    longDescription = ''
      A free, open source, flexible and extensible screen reader that provides
      access to the graphical desktop via speech and refreshable braille.
      It works with applications and toolkits that support the Assistive
      Technology Service Provider Interface (AT-SPI). That includes the GNOME
      GTK toolkit, the Java platform's Swing toolkit, LibreOffice, Gecko, and
      WebKitGtk. AT-SPI support for the KDE Qt toolkit is being pursued.

      Needs `services.gnome.at-spi2-core.enable = true;` in `configuration.nix`.
    '';
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
