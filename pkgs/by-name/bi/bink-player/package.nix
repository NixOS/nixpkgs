{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  p7zip,
  libGL,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "bink-player";
  version = "2025.05";

  src = fetchurl {
    url = "https://www.radgametools.com/down/Bink/BinkLinuxPlayer.7z";
    hash = "sha256-A3IDQtdYlIcU2U8uieQI6xe1SvW4BqH+5ZwPYJxr83M=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    p7zip
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libGL
    libX11
  ];

  unpackPhase = ''
    7z x $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./BinkPlayer64 $out/bin/bink-player
    chmod +x $out/bin/bink-player

    runHook postInstall
  '';

  meta = {
    description = "Play videos in the Bink format";
    homepage = "https://www.radgametools.com/bnkmain.htm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "bink-player";
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = lib.platforms.linux;
  };
}
