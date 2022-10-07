{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, libcap
, zlib
, libcxx
, fontconfig
, icu
, openssl
, libX11
}:

stdenv.mkDerivation rec {
  pname = "watt-toolkit";
  version = "2.8.4";

  src = fetchurl {
    url = "https://github.com/BeyondDimension/SteamTools/releases/download/${version}/Steam++_linux_x64_v${version}.deb";
    sha256 = "sha256-s44C8RKmj9TtmG37O2mLrut+JWkHnA//DoNANelCBHs=";
  };

  icon = fetchurl {
    url = "https://github.com/BeyondDimension/SteamTools/raw/${version}/resources/AppIcon/Logo_64.png";
    sha256 = "sha256-HH4rFntrRXxoXQ1IkBR+33DrKj7u+xKqQt3QxyGy9J0=";
  };

  buildInputs = [
    libcap
    zlib
    libcxx
    fontconfig
    icu
    openssl
    libX11
  ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper copyDesktopItems ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems = lib.toList (makeDesktopItem {
    name = "watt-toolkit";
    exec = "watt-toolkit";
    icon = "watt-toolkit";
    comment = "A cross-platform Steam toolbox";
    desktopName = "Watt Toolkit";
    categories = [ "Utility" ];
    keywords = [ "Steam" "Steam++" "WattToolkit" ];
  });

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/watt-toolkit
    install -Dm755 usr/share/Steam++/* $out/opt/watt-toolkit
    install -Dm644 $icon $out/share/icons/hicolor/64x64/apps/watt-toolkit.png

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/watt-toolkit/Steam++ $out/bin/watt-toolkit \
      --argv0 "watt-toolkit" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = with lib; {
    description = "A cross-platform Steam toolbox";
    homepage = "https://steampp.net";
    changelog = "https://steampp.net/changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
