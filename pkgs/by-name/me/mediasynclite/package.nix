{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  glib,
  gsettings-desktop-schemas,
  pkg-config,
  curl,
  openssl,
  jansson,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mediasynclite";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "iBroadcastMediaServices";
    repo = "MediaSyncLiteLinux";
    rev = finalAttrs.version;
    hash = "sha256-vnajWmQfKJ3ff/O4IROXiRAKEGu/6EMX9/oApwcwoaU=";
  };

  buildInputs = [
    curl
    glib
    gtk3
    openssl
    jansson
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gsettings-desktop-schemas
    pkg-config
    wrapGAppsHook3
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    substitute ./src/ibmsl.c ./src/ibmsl.c --subst-var out
  '';

  meta = {
    description = "Linux-native graphical uploader for iBroadcast";
    downloadPage = "https://github.com/tobz619/MediaSyncLiteLinuxNix";
    homepage = "https://github.com/iBroadcastMediaServices/MediaSyncLiteLinux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tobz619 ];
  };
})
