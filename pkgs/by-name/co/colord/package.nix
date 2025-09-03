{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  bash-completion,
  glib,
  polkit,
  pkg-config,
  gettext,
  gusb,
  lcms2,
  sqlite,
  udev,
  systemd,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  dbus,
  gobject-introspection,
  argyllcms,
  meson,
  mesonEmulatorHook,
  ninja,
  vala,
  libgudev,
  wrapGAppsNoGuiHook,
  shared-mime-info,
  sane-backends,
  docbook_xsl,
  docbook_xsl_ns,
  docbook_xml_dtd_412,
  gtk-doc,
  libxslt,
  enableDaemon ? true,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "colord";
  version = "1.4.6";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
    "installedTests"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/colord-${version}.tar.xz";
    sha256 = "dAdjGie/5dG2cueuQndwAcEF2GC3tzkig8jGMA3ojm8=";
  };

  patches = [
    # Put installed tests into its own output
    ./installed-tests-path.patch
  ];

  postPatch = ''
    for file in data/tests/meson.build lib/colord/cd-test-shared.c lib/colord/meson.build; do
        substituteInPlace $file --subst-var-by installed_tests_dir "$installedTests"
    done
  '';

  mesonFlags = [
    "--localstatedir=/var"
    "-Dinstalled_tests=true"
    "-Dlibcolordcompat=true"
    "-Dsane=true"
    "-Dvapi=true"
    "-Ddaemon=${lib.boolToString enableDaemon}"
    "-Ddaemon_user=colord"
    (lib.mesonBool "systemd" enableSystemd)

    # The presence of the "udev" pkg-config module (as opposed to "libudev")
    # indicates whether rules are supported.
    (lib.mesonBool "udev_rules" (lib.elem "udev" udev.meta.pkgConfigModules))
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xsl
    docbook_xsl_ns
    gettext
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    shared-mime-info
    vala
    wrapGAppsNoGuiHook
    udevCheckHook
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    argyllcms
    bash-completion
    dbus
    glib
    gusb
    lcms2
    libgudev
    sane-backends
    sqlite
    udev
  ]
  ++ lib.optionals enableSystemd [
    systemd
  ]
  ++ lib.optionals enableDaemon [
    polkit
  ];

  doInstallCheck = true;

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_TMPFILESDIR = "${placeholder "out"}/lib/tmpfiles.d";
  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR = "${placeholder "out"}/share/bash-completion/completions";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.colord;
    };
  };

  meta = with lib; {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = "https://www.freedesktop.org/software/colord/";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.marcweber ];
    teams = [ teams.freedesktop ];
    platforms = platforms.linux;
  };
}
