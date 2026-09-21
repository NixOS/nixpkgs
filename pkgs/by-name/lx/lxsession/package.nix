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
  gtk3,
  libx11,
  polkit,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxsession";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxsession";
    tag = finalAttrs.version;
    hash = "sha256-7dtQ6DgJxLO2T1Ioh/onMMkhvtt/JmaBIWEVSjuJTf8=";
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
    gtk3
    libx11
    polkit
    vala
  ];

  configureFlags = [
    "--enable-man"
    "--disable-buildin-clipboard"
    "--disable-buildin-polkit"
    "--enable-gtk3"
  ];

  postPatch = ''
    mkdir -p m4
  '';

  patches = [ ./repect-xml-catalog-file-var.patch ];

  meta = {
    homepage = "https://wiki.lxde.org/en/LXSession";
    description = "Classic LXDE session manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lxsession";
  };
})
