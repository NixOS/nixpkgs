{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  docbook_xml_dtd_412,
  docbook_xsl,
  intltool,
  libxml2,
  libxslt,
  pkg-config,
  wrapGAppsHook3,
  gtk2-x11,
  libX11,
  polkit,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxsession";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxsession";
    tag = finalAttrs.version;
    hash = "sha256-3RnRF4oMCtZbIraHVqEPnkviAkELq7uYqyHY0uCf/lU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    libxml2
    libxslt
    pkg-config
    wrapGAppsHook3
    docbook_xml_dtd_412
    docbook_xsl
  ];

  buildInputs = [
    gtk2-x11
    libX11
    polkit
    vala
  ];

  configureFlags = [
    "--enable-man"
    "--disable-buildin-clipboard"
    "--disable-buildin-polkit"
  ];

  postPatch = ''
    mkdir -p m4
  '';

  patches = [ ./repect-xml-catalog-file-var.patch ];

  meta = {
    homepage = "https://wiki.lxde.org/en/LXSession";
    description = "Classic LXDE session manager";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.shamilton ];
    platforms = lib.platforms.linux;
    mainProgram = "lxsession";
  };
})
