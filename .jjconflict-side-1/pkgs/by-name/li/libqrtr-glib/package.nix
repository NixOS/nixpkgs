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

stdenv.mkDerivation (finalAttrs: {
  pname = "libqrtr-glib";
  version = "1.4.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libqrtr-glib";
    rev = finalAttrs.version;
    sha256 = "sha256-1zsGwZogsI0QvIvvQy5FhcRSq2Q75/J724OcM+K/QBo=";
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

  meta = {
    homepage = "https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib";
    description = "Qualcomm IPC Router protocol helper library";
    teams = [ lib.teams.freedesktop ];
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2Plus;
  };
})
