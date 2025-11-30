{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  gobject-introspection,
  meson,
  ninja,
  perl,
  gettext,
  gtk-doc,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  gusb,
  dbus,
  polkit,
  nss,
  pam,
  systemd,
  libfprint,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fprintd";
  version = "1.94.5";
  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = "fprintd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-aGIz50S0zfE3rV6QJp8iQz3uUVn8WAL68KU70j8GyOU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    perl # for pod2man
    gettext
    gtk-doc
    python3
    libxslt
    dbus
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    polkit
    nss
    pam
    systemd
    libfprint
  ];

  nativeCheckInputs = with python3.pkgs; [
    gobject-introspection # for setup hook
    python-dbusmock
    dbus-python
    pygobject3
    pycairo
    pypamtest
    gusb # Required by libfprint’s typelib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  PKG_CONFIG_DBUS_1_INTERFACES_DIR = "${placeholder "out"}/share/dbus-1/interfaces";
  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";
  PKG_CONFIG_DBUS_1_DATADIR = "${placeholder "out"}/share";

  # FIXME: Ugly hack for tests to find libpam_wrapper.so
  LIBRARY_PATH = lib.makeLibraryPath [ python3.pkgs.pypamtest ];

  mesonCheckFlags = [
    # PAM related checks are timing out
    "--no-suite"
    "fprintd:TestPamFprintd"
  ];

  patches = [
    # Skip flaky test "test_removal_during_enroll"
    # https://gitlab.freedesktop.org/libfprint/fprintd/-/issues/129
    ./skip-test-test_removal_during_enroll.patch
  ];

  postPatch = ''
    patchShebangs \
      po/check-translations.sh \
      tests/unittest_inspector.py

    # Stop tests from failing due to unhandled GTasks uncovered by GLib 2.76 bump.
    # https://gitlab.freedesktop.org/libfprint/fprintd/-/issues/151
    substituteInPlace tests/fprintd.py \
      --replace "env['G_DEBUG'] = 'fatal-criticals'" ""
    substituteInPlace tests/meson.build \
      --replace "'G_DEBUG=fatal-criticals'," ""
  '';

  meta = {
    homepage = "https://fprint.freedesktop.org/";
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
