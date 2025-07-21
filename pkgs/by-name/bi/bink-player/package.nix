{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  p7zip,
  libGL,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bink-player";
  version = "2025.05";

  src = fetchurl {
    url = "https://web.archive.org/web/20250602103030if_/https://www.radgametools.com/down/Bink/BinkLinuxPlayer.7z";
    hash = "sha256-A3IDQtdYlIcU2U8uieQI6xe1SvW4BqH+5ZwPYJxr83M=";
  };

  unpackPhase = ''
    runHook preUnpack

    7z x $src

    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    p7zip
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libGL
    libX11
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 BinkPlayer64 -t $out/bin/
    install -Dm755 BinkPlayer -t $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Play videos in the Bink format";
    homepage = "https://www.radgametools.com/bnkmain.htm";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "BinkPlayer64";
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = [ "x86_64-linux" ];
  };
})
