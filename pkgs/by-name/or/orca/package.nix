{
  lib,
  stdenv,
  buildPackages,
  pkg-config,
  fetchurl,
  meson,
  ninja,
  wrapGAppsHook3,
  gobject-introspection,
  gettext,
  yelp-tools,
  itstool,
  python3,
  gtk3,
  gnome,
  replaceVars,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  xkbcomp,
  procps,
  cargo,
  rustc,
  rustPlatform,
  gsettings-desktop-schemas,
  speechd-minimal,
  brltty,
  liblouis,
  gst_all_1,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "orca";
  version = "51.beta";

  pyproject = false;

  src = fetchurl {
    url = "mirror://gnome/sources/orca/${lib.versions.major finalAttrs.version}/orca-${finalAttrs.version}.tar.xz";
    hash = "sha256-b5SJa5WTil+lPIQus9p56dRKdkw9PCT4gp5Rb/pb6h0=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      pgrep = "${procps}/bin/pgrep";
      xkbcomp = "${xkbcomp}/bin/xkbcomp";
    })
  ];

  cargoRoot = "subprojects/mathcat-py";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-MaHjaJAi7JlQ7x0pDKoHrLYyenLeG+w8bhw1GW7IX+g=";
  };

  # needed for cross-compilation
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    # cross-compilation support requires the host environment's build time
    # to make the following buildPackages available.
    buildPackages.gtk3
    buildPackages.python3
    buildPackages.python3Packages.pygobject3
    meson
    ninja
    wrapGAppsHook3
    pkg-config
    cargo
    rustc
    rustPlatform.cargoSetupHook
    gettext
    yelp-tools
    itstool
    gobject-introspection
  ];

  pythonPath = with python3.pkgs; [
    dasbus
    pygobject3
    pyxdg
    brltty
    liblouis
    psutil
    speechd-minimal
    gst-python
    setproctitle
    at-spi2-core
  ];

  strictDeps = false;

  buildInputs = [
    python3
    gtk3
    at-spi2-atk
    at-spi2-core
    dbus
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest
  ];

  checkInputs = with python3.pkgs; [
    pytest-mock
  ];

  postPatch = ''
    # Disable broken tests
    substituteInPlace tests/meson.build \
      --replace-fail "  'unit_tests/test_preferences_grid_base.py'," "" \
      --replace-fail "  'unit_tests/test_braille_presenter.py'," "" \
      --replace-fail "  'unit_tests/test_profile_manager.py'," ""
  '';

  # Help GI find typelibs during Meson's configure step in cross builds
  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    export GI_TYPELIB_PATH=${buildPackages.gtk3}/lib/girepository-1.0''${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}
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
