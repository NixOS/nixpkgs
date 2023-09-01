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
  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/SpikeHD/Dorion/releases/download/v${version}/Dorion_${version}_amd64_portable.tar.gz";
    sha256 = "sha256-QvETUcnN2pFSlaXPzylmrqxDrI3aT0/YqwjHsiPpFNk=";
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

  installPhase = ''
    mkdir -p $out/bin
    mv html icons injection plugins themes dorion $out/bin
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
