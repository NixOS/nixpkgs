{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  wineWowPackages,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "slushload";
  version = "3";

  src = fetchzip {
    url = "https://csdb.dk/getinternalfile.php/222989/slushload_v${finalAttrs.version}.zip";
    hash = "sha256-xXcLaEsM+4IrAi96JyPRCdIhQ8jhf44/4E3Ba18mddE=";
    stripRoot = false;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    makeWrapper ${wineWowPackages.base}/bin/wine $out/bin/slushload \
      --set WINEDEBUG "-all" \
      --run "export WINEPREFIX=''${XDG_DATA_HOME:-\$HOME/.local/share}/slushload" \
      --add-flags $src/slushload_v3.exe

    cp $src/huffmanloader.asm $out/share
    cp $src/readme.txt $out/share

    runHook postInstall
  '';

  meta = {
    description = "Make turbo tape images from .prg files";
    homepage = "https://csdb.dk/release/?id=212586";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "slushload";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
