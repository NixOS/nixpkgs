{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  testers,
  accountsservice,
  cmake,
  dbus-test-runner,
  withDocumentation ? true,
  docbook_xsl,
  docbook_xml_dtd_45,
  glib,
  gobject-introspection,
  gtest,
  gtk-doc,
  intltool,
  lomiri,
  pkg-config,
  python3,
  systemd,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-messages";
  version = "24.5.1";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-messages";
    tag = finalAttrs.version;
    hash = "sha256-M6IXI0ZnWPZod2ewxxfCeHhdYUrWDW/BFc1vMHmjObA=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [ "devdoc" ];

  postPatch = ''
    # Uses pkg_get_variable, cannot substitute prefix with that
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    # Bad concatenation
    substituteInPlace libmessaging-menu/messaging-menu.pc.in \
      --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'

    # Fix tests with gobject-introspection 1.80 not installing GLib introspection data
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail 'GI_TYPELIB_PATH=\"' 'GI_TYPELIB_PATH=\"$GI_TYPELIB_PATH$\{GI_TYPELIB_PATH\:+\:\}'
  ''
  + lib.optionalString (!withDocumentation) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(doc)' '# add_subdirectory(doc)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # For glib-compile-schemas
    intltool
    pkg-config
    vala
    wrapGAppsHook3
  ]
  ++ lib.optionals withDocumentation [
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
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        python-dbusmock
      ]
    ))
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
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
    ayatana-indicators = {
      ayatana-indicator-messages = [
        "ayatana"
        "lomiri"
      ];
    };
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      vm = nixosTests.ayatana-indicators;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana Indicator Messages Applet";
    longDescription = ''
      The -messages Ayatana System Indicator is the messages menu indicator for Unity7, MATE and Lomiri (optionally for
      others, e.g. XFCE, LXDE).
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-messages";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-messages/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    pkgConfigModules = [ "messaging-menu" ];
  };
})
