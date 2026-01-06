{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  libX11,
  gtk2,
  gtk3,
  libxslt,
  docbook_xsl,
  wrapGAppsHook3,
  withGtk3 ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxappearance";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxappearance";
    tag = finalAttrs.version;
    hash = "sha256-t5P3JYGZzhTaJ3s23r6yrAQoFcCV5uteHh67sWY1KrI=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
    autoreconfHook
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    libX11
    (if withGtk3 then gtk3 else gtk2)
  ];

  patches = [
    ./lxappearance-0.6.3-xdg.system.data.dirs.patch
  ];

  env.XSLTPROC = lib.getExe' libxslt "xsltproc";

  configureFlags = lib.optional withGtk3 "--enable-gtk3";

  meta = {
    description = "Lightweight program for configuring the theme and fonts of gtk applications";
    mainProgram = "lxappearance";
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
