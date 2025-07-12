{
  stdenv,
  lib,
  meson,
  ninja,
  pkg-config,
  fetchFromGitLab,
  fetchpatch,
  python3,
  umockdev,
  gobject-introspection,
  dbus,
  asciidoc,
  libxml2,
  libxslt,
  docbook_xml_dtd_45,
  docbook-xsl-nons,
  glib,
  systemd,
  polkit,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  version = "0.9.8";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "bolt";
    repo = "bolt";
    rev = version;
    hash = "sha256-sDPipSIT2MJMdsOjOQSB+uOe6KXzVnyAqcQxPPr2NsU=";
  };

  patches = [
    # Test does not work on ZFS with atime disabled.
    # Upstream issue: https://gitlab.freedesktop.org/bolt/bolt/-/issues/167
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/bolt/bolt/-/commit/c2f1d5c40ad71b20507e02faa11037b395fac2f8.diff";
      revert = true;
      hash = "sha256-6w7ll65W/CydrWAVi/qgzhrQeDv1PWWShulLxoglF+I=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook-xsl-nons
    libxml2
    libxslt
    meson
    ninja
    pkg-config
    glib
    udevCheckHook
  ];

  buildInputs = [
    polkit
    systemd
  ];

  preCheck = ''
    export LD_LIBRARY_PATH=${umockdev.out}/lib/
  '';

  nativeCheckInputs = [
    dbus
    gobject-introspection
    umockdev
    (python3.pythonOnBuildForHost.withPackages (p: [
      p.pygobject3
      p.dbus-python
      p.python-dbusmock
    ]))
  ];

  postPatch = ''
    patchShebangs scripts tests
  '';

  mesonFlags = [
    "-Dlocalstatedir=/var"
  ];

  doInstallCheck = true;

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  meta = with lib; {
    description = "Thunderbolt 3 device management daemon";
    mainProgram = "boltctl";
    homepage = "https://gitlab.freedesktop.org/bolt/bolt";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
