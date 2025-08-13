{
  fetchurl,
  lib,
  stdenv,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gnome,
  gtk3,
  gtk4,
  atk,
  gobject-introspection,
  spidermonkey_128,
  pango,
  cairo,
  readline,
  libsysprof-capture,
  glib,
  libxml2,
  dbus,
  gdk-pixbuf,
  harfbuzz,
  makeWrapper,
  which,
  xvfb-run,
  nixosTests,
  installTests ? true,
}:

let
  testDeps = [
    gtk3
    gtk4
    atk
    pango.out
    gdk-pixbuf
    harfbuzz
    glib.out
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gjs";
  version = "1.84.2";

  outputs = [
    "out"
    "dev"
    "installedTests"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${lib.versions.majorMinor finalAttrs.version}/gjs-${finalAttrs.version}.tar.xz";
    hash = "sha256-NRQu3zRXBWNjACkew6fVg/FJaf8/rg/zD0qVseZ0AWY=";
  };

  patches = [
    # Hard-code various paths
    ./fix-paths.patch

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch

    # Disable introspection test in installed tests
    # (minijasmine:1317): GLib-GIO-WARNING **: 17:33:39.556: Error creating IO channel for /proc/self/mountinfo: No such file or directory (g-io-error-quark, 1)
    ./disable-introspection-test.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    which # for locale detection
    libxml2 # for xml-stripblanks
    dbus # for dbus-run-session
    gobject-introspection
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    cairo
    readline
    libsysprof-capture
    spidermonkey_128
  ];

  nativeCheckInputs = [
    xvfb-run
  ]
  ++ testDeps;

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isMusl) [
    "-Dprofiler=disabled"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    patchShebangs build/choose-tests-locale.sh
    substituteInPlace installed-tests/debugger-test.sh --subst-var-by gjsConsole $out/bin/gjs-console
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace installed-tests/js/meson.build \
      --replace "'Encoding'," "#'Encoding',"
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overridden during installation.
    mkdir -p $out/lib $installedTests/libexec/installed-tests/gjs
    ln -s $PWD/libgjs.so.0 $out/lib/libgjs.so.0
    ln -s $PWD/subprojects/gobject-introspection-tests/libgimarshallingtests.so $installedTests/libexec/installed-tests/gjs/libgimarshallingtests.so
    ln -s $PWD/subprojects/gobject-introspection-tests/libregress.so $installedTests/libexec/installed-tests/gjs/libregress.so
    ln -s $PWD/subprojects/gobject-introspection-tests/libutility.so $installedTests/libexec/installed-tests/gjs/libutility.so
    ln -s $PWD/subprojects/gobject-introspection-tests/libwarnlib.so $installedTests/libexec/installed-tests/gjs/libwarnlib.so
    ln -s $PWD/installed-tests/js/libgjstesttools/libgjstesttools.so $installedTests/libexec/installed-tests/gjs/libgjstesttools.so
  '';

  postInstall = ''
    # TODO: make the glib setup hook handle moving the schemas in other outputs.
    installedTestsSchemaDatadir="$installedTests/share/gsettings-schemas/gjs-${finalAttrs.version}"
    mkdir -p "$installedTestsSchemaDatadir"
    mv "$installedTests/share/glib-2.0" "$installedTestsSchemaDatadir"
  '';

  postFixup = lib.optionalString installTests ''
    wrapProgram "$installedTests/libexec/installed-tests/gjs/minijasmine" \
      --prefix XDG_DATA_DIRS : "$installedTestsSchemaDatadir" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" testDeps}"
  '';

  checkPhase = ''
    runHook preCheck
    GTK_A11Y=none \
    HOME=$(mktemp -d) \
    xvfb-run -s '-screen 0 800x600x24' \
      meson test --print-errorlogs
    runHook postCheck
  '';

  separateDebugInfo = stdenv.hostPlatform.isLinux;

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.gjs;
    };

    updateScript = gnome.updateScript {
      packageName = "gjs";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "JavaScript bindings for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gjs/blob/master/doc/Home.md";
    license = licenses.lgpl2Plus;
    mainProgram = "gjs";
    teams = [ teams.gnome ];
    inherit (gobject-introspection.meta) platforms badPlatforms;
  };
})
