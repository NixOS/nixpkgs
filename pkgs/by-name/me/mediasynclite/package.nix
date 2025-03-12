{ lib
, stdenv
, fetchFromGitHub
, gtk3
, glib
, gsettings-desktop-schemas
, copyDesktopItems
, makeDesktopItem
, pkg-config
, curl
, openssl
, jansson
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "mediasynclite";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "iBroadcastMediaServices";
    repo = "MediaSyncLiteLinux";
    rev = version;
    hash = "sha256-ToSkR6tPJMBCcj1NUBAywKjCAPlpmh+ngIopFrT2PIA=";
  };

  buildInputs = [
    curl
    openssl
    jansson
    gtk3
    glib
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gsettings-desktop-schemas
    pkg-config
    wrapGAppsHook3
    copyDesktopItems
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/share/icons
    cp -rv share/* $out/share
  '';

  postPatch = ''
      substituteInPlace src/ibmsl.c --replace-fail "share/ui" "$out/share/ui"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = lib.toLower pname;
      desktopName = "iBroadcast Mediasynclite";
      comment = meta.description;
      exec = "mediasynclite";
      keywords = [ "iBroadcast" "mediasynclite" ];
      categories = [ "GTK" "Music" ];
      terminal = false;
      type = "Application";
      icon = "mediasynclite";
    })
  ];

  meta = with lib; {
    description = "A Linux-native graphical uploader for iBroadcast";
    downloadPage = "https://github.com/tobz619/MediaSyncLiteLinuxNix";
    homepage = "https://github.com/iBroadcastMediaServices/MediaSyncLiteLinux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tobz619 ];
  };
}
