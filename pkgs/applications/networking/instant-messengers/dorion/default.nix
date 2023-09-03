{ lib
, stdenv
, dpkg
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, webkitgtk
, glib-networking
, libappindicator
, libayatana-appindicator
, gst_all_1
}:

stdenv.mkDerivation (finalAttrs: {
  name = "dorion";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/SpikeHD/Dorion/releases/download/v${finalAttrs.version}/Dorion_${finalAttrs.version}_amd64.deb";
    hash = "sha256-IYqJ5mz+XGHf4GVSW2Mq/z8xWLs4Y4KRWZ6fAtIg2tk=";
  };

  unpackCmd = ''
    dpkg-deb -x $curSrc source
  '';

  runtimeDependencies = [
    glib-networking
    libappindicator
    libayatana-appindicator
  ];

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk
    glib-networking
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/share/ $out
    mkdir -p $out/usr/lib/dorion/data/usr
    mv usr/{bin,lib} $out/usr/lib/dorion/data/usr
    ln -s $out/usr/lib/dorion/data/usr/bin/dorion $out/bin/dorion

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tiny alternative Discord client with a smaller footprint, themes and plugins, multi-profile, and more!";
    homepage = "https://github.com/SpikeHD/Dorion";
    maintainers = with maintainers; [ knarkzel nyanbinary ];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    mainProgram = "dorion";
  };
})
