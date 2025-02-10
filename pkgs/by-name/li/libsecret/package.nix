{
  stdenv,
  lib,
  fetchurl,
  glib,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxslt,
  python3,
  python3Packages,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  libgcrypt,
  gobject-introspection,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  vala,
  gi-docgen,
  gnome,
  gjs,
  libintl,
  dbus,
}:

stdenv.mkDerivation rec {
  pname = "libsecret";
  version = "0.21.6";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/libsecret/${lib.versions.majorMinor version}/libsecret-${version}.tar.xz";
    hash = "sha256-dHuMF1vhCMiA0637nDU36mblIOStLcz13OWAA67soJA=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      gettext
      libxslt # for xsltproc for building man pages
      docbook-xsl-nons
      docbook_xml_dtd_42
      libintl
      vala
      glib
    ]
    ++ lib.optionals withIntrospection [
      gi-docgen
      gobject-introspection
    ];

  buildInputs = [
    libgcrypt
  ];

  propagatedBuildInputs = [
    glib
  ];

  nativeCheckInputs = [
    python3
    python3Packages.dbus-python
    python3Packages.pygobject3
    dbus
    gjs
  ];

  mesonFlags = [
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "gtk_doc" withIntrospection)
    (lib.mesonOption "bashcompdir" "share/bash-completion/completions")
  ];

  doCheck = stdenv.hostPlatform.isLinux && withIntrospection;
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs ./tool/test-*.sh

    # dbus-run-session defaults to FHS path
    substituteInPlace meson.build --replace-fail \
      "exe_wrapper: dbus_run_session," \
      "exe_wrapper: [dbus_run_session, '--config-file=${dbus}/share/dbus-1/session.conf'],"
  '';

  preCheck = ''
    # Our gobject-introspection patches make the shared library paths absolute
    # in the GIR files. When running tests, the library is not yet installed,
    # though, so we need to replace the absolute path with a local one during build.
    # We are using a symlink that will be overwitten during installation.
    mkdir -p $out/lib $out/lib
    ln -s "$PWD/libsecret/libmock-service.so" "$out/lib/libmock-service.so"
    ln -s "$PWD/libsecret/libsecret-1.so.0" "$out/lib/libsecret-1.so.0"
  '';

  checkPhase = ''
    runHook preCheck

    meson test --print-errorlogs --timeout-multiplier 0

    runHook postCheck
  '';

  postCheck = ''
    # This is test-only so it won’t be overwritten during installation.
    rm "$out/lib/libmock-service.so"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libsecret";
      # Does not seem to use the odd-unstable policy: https://gitlab.gnome.org/GNOME/libsecret/issues/30
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Library for storing and retrieving passwords and other secrets";
    homepage = "https://gitlab.gnome.org/GNOME/libsecret";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "secret-tool";
    inherit (glib.meta) platforms maintainers;
  };
}
