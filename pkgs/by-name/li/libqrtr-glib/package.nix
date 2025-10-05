{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gobject-introspection,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "libqrtr-glib";
  version = "1.2.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libqrtr-glib";
    rev = version;
    sha256 = "kHLrOXN6wgBrHqipo2KfAM5YejS0/bp7ziBSpt0s1i0=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib";
    description = "Qualcomm IPC Router protocol helper library";
    teams = [ teams.freedesktop ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
