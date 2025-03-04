{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  copyDesktopItems,
  pango,
  gtk3,
  alsa-lib,
  nss,
  libXdamage,
  libdrm,
  libgbm,
  libxshmfence,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  gcc-unwrapped,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "bluemail";
  version = "1.140.8-1922";

  # Taking a snapshot of the DEB release because there are no tagged version releases.
  # For new versions, download the upstream release, extract it and check for the version string.
  # In case there's a new version, create a snapshot of it on https://archive.org before updating it here.
  src = fetchurl {
    url = "https://web.archive.org/web/20240208120704/https://download.bluemail.me/BlueMail/deb/BlueMail.deb";
    hash = "sha256-dnYOb3Q/9vSDssHGS2ywC/Q24Oq96/mvKF+eqd/4dVw=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "bluemail";
      icon = "bluemail";
      exec = "bluemail";
      desktopName = "BlueMail";
      comment = meta.description;
      genericName = "Email Reader";
      mimeTypes = [
        "x-scheme-handler/me.blueone.linux"
        "x-scheme-handler/mailto"
      ];
      categories = [ "Office" ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    pango
    gtk3
    alsa-lib
    nss
    libXdamage
    libdrm
    libgbm
    libxshmfence
    udev
  ];

  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv opt/BlueMail/* $out
    ln -s $out/bluemail $out/bin/bluemail

    mkdir -p $out/share/icons
    mv usr/share/icons/hicolor $out/share/icons/

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        gcc-unwrapped.lib
        gtk3
        udev
      ]
    }"
    "--prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}"
  ];

  preFixup = ''
    wrapProgram $out/bin/bluemail \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Free, secure, universal email app, capable of managing an unlimited number of mail accounts";
    homepage = "https://bluemail.me";
    license = licenses.unfree;
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ onny ];
  };
}
