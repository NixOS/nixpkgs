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
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-messages";
  version = "24.5.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-messages";
    rev = finalAttrs.version;
    hash = "sha256-D1181eD2mAVXEa7RLXXC4b2tVGrxbh0WWgtbC1anHH0=";
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

    # Fix tests with gobject-introspection 1.80 not installing GLib introspection data
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail 'GI_TYPELIB_PATH=\"' 'GI_TYPELIB_PATH=\"$GI_TYPELIB_PATH$\{GI_TYPELIB_PATH\:+\:\}'
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
    wrapGAppsHook3
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

  # Indicators that talk to it may issue requests to parse desktop files, which needs binaries in Exec on PATH
  # messaging_menu_app_set_desktop_id -> g_desktop_app_info_new -...-> g_desktop_app_info_load_from_keyfile -> g_find_program_for_path
  # When launched via systemd, PATH is very narrow
  preFixup = ''
    gappsWrapperArgs+=(
      --suffix PATH : '/run/current-system/sw/bin'
    )
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
