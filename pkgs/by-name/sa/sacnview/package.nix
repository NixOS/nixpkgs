{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  cmake,
  qt6,
  libpcap,
}:
let
  desktopItem = makeDesktopItem {
    name = "sacnview";
    desktopName = "sACNView";
    icon = "sacnview";
    comment = "A tool for monitoring and sending the Streaming ACN lighting control protocol used in theatres, TV studios and architectural systems.";
    exec = "sACNView";
    categories = [ "Network" ];
  };
in
stdenv.mkDerivation rec {
  pname = "sacnview";
  version = "v3.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "docsteer";
    repo = "sacnview";
    rev = version;
    hash = "sha256-ZHHfKtc30MA6d746bBTIAbdSudEEzSzNNNPe/eLDBjU=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = [
    qt6.qtbase
    cmake
  ];

  buildInputs = [
    libpcap
    qt6.qtmultimedia
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  # Copy binary, .desktop file and icon to $out
  installPhase = ''
    mkdir -p $out/bin
    cp sACNView $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/128x128/apps/
    cp ${desktopItem}/share/applications/sacnview.desktop $out/share/applications/sacnview.desktop
    cp ${src}/res/Logo.png $out/share/icons/hicolor/128x128/apps/sacnview.png
    runHook postInstall
  '';

  meta = src.meta // {
    description = "A tool for monitoring and sending the Streaming ACN lighting control protocol used in theatres, TV studios and architectural systems.";
    changelog = "https://github.com/docsteer/sacnview/releases/tag/${version}";
    homepage = "https://sacnview.org/";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ zax71 ];
    platforms = lib.platforms.linux;
    mainProgram = "sacnview";
  };
}
