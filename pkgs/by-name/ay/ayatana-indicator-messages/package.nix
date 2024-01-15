{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, nixosTests
, testers
, accountsservice
, cmake
, dbus-test-runner
, withDocumentation ? true
, docbook_xsl
, docbook_xml_dtd_45
, glib
, gobject-introspection
, gtest
, gtk-doc
, intltool
, lomiri
, pkg-config
, python3
, systemd
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-messages";
  version = "23.10.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-messages";
    rev = finalAttrs.version;
    hash = "sha256-FBJeP5hOXJcOk04cRJpw+oN7L3w3meDX3ivLmFWkhVI=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withDocumentation [
    "devdoc"
  ];

  postPatch = ''
    # Uses pkg_get_variable, cannot substitute prefix with that
    substituteInPlace data/CMakeLists.txt \
      --replace "\''${SYSTEMD_USER_DIR}" "$out/lib/systemd/user"

    # Bad concatenation
    substituteInPlace libmessaging-menu/messaging-menu.pc.in \
      --replace "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '' + lib.optionalString (!withDocumentation) ''
    sed -i CMakeLists.txt \
      '/add_subdirectory(doc)/d'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # For glib-compile-schemas
    intltool
    pkg-config
    vala
    wrapGAppsHook
  ] ++ lib.optionals withDocumentation [
    docbook_xsl
    docbook_xml_dtd_45
    gtk-doc
  ];

  buildInputs = [
    accountsservice
    lomiri.cmake-extras
    glib
    gobject-introspection
    systemd
  ];

  nativeCheckInputs = [
    (python3.withPackages (ps: with ps; [
      pygobject3
      python-dbusmock
    ]))
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.doCheck}"
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
  ];

  makeFlags = lib.optionals withDocumentation [
    # gtk-doc doesn't call ld with the correct arguments
    # ld: ...: undefined reference to symbol 'strncpy@@GLIBC_2.2.5', 'qsort@@GLIBC_2.2.5'
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    # test-client imports gir, whose solib entry points to final store location
    install -Dm644 libmessaging-menu/libmessaging-menu.so.0.0.0 $out/lib/libmessaging-menu.so.0
  '';

  postCheck = ''
    # remove the above solib-installation, let it be done properly
    rm -r $out
  '';

  preInstall = lib.optionalString withDocumentation ''
    # installing regenerates docs, generated files are created without write permissions, errors out while trying to overwrite them
    chmod +w doc/reference/html/*
  '';

  passthru = {
    ayatana-indicators = [
      "ayatana-indicator-messages"
    ];
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      vm = nixosTests.ayatana-indicators;
    };
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Ayatana Indicator Messages Applet";
    longDescription = ''
      The -messages Ayatana System Indicator is the messages menu indicator for Unity7, MATE and Lomiri (optionally for
      others, e.g. XFCE, LXDE).
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-messages";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
    pkgConfigModules = [
      "messaging-menu"
    ];
  };
})
