{
  stdenv,
  lib,
  dpkg,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook,
  webkitgtk,
  glib-networking,
  libappindicator,
  libayatana-appindicator,
  gst_all_1,
}:
stdenv.mkDerivation rec {
  name = "dorion";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/SpikeHD/Dorion/releases/download/v${version}/Dorion_${version}_amd64.deb";
    sha256 = "sha256-IYqJ5mz+XGHf4GVSW2Mq/z8xWLs4Y4KRWZ6fAtIg2tk=";
  };

  runtimeDependencies = [
    libappindicator
    libayatana-appindicator
    glib-networking
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

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    mkdir -p $out/bin
    mv usr/share/ $out
    mkdir -p $out/usr/lib/dorion/data/usr
    mv usr/{bin,lib} $out/usr/lib/dorion/data/usr
    ln -s $out/usr/lib/dorion/data/usr/bin/dorion $out/bin/dorion
  '';

  meta = with lib; {
    description = "Tiny alternative Discord client with a smaller footprint, themes and plugins, multi-profile, and more!";
    homepage = "https://github.com/SpikeHD/Dorion";
    maintainers = with maintainers; [knarkzel nyanbinary];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    platforms = platforms.linux;
    mainProgram = "dorion";
  };
}
