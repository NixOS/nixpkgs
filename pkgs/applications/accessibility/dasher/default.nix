{
  stdenv,
  lib,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  expat,
  itstool,
  gnome-doc-utils,
  which,
  at-spi2-core,
  dbus,
  libxslt,
  libxml2,
  speechSupport ? true,
  speechd,
}:

stdenv.mkDerivation {
  pname = "dasher";
  version = "unstable-2021-04-25";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "dasher";
    rev = "90c753b87564fa3f42cb2d04e1eb6662dc8e0f8f";
    sha256 = "sha256-aM05CV68pCRlhfIPyhuHWeRL+tDroB3fVsoX08OU8hY=";
  };

  prePatch = ''
    # tries to invoke git for something, probably fetching the ref
    echo "true" > build-aux/mkversion
  '';

  configureFlags = lib.optional (!speechSupport) "--disable-speech";

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook3
    pkg-config
    # doc generation
    gnome-doc-utils
    which
    libxslt
    libxml2
  ];

  buildInputs = [
    glib
    gtk3
    expat
    itstool
    # at-spi2 needs dbus to be recognized by pkg-config
    at-spi2-core
    dbus
  ] ++ lib.optional speechSupport speechd;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.inference.org.uk/dasher/";
    description = "Information-efficient text-entry interface, driven by natural continuous pointing gestures";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "dasher";
  };
}
