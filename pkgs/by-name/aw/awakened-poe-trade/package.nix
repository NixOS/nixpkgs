{
  lib,
  fetchurl,
  stdenv,
  appimageTools,
  makeWrapper,
  electron,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "awakened-poe-trade";
  version = "3.25.102";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/Awakened-PoE-Trade-${version}.AppImage";
    hash = "sha256-lcdKJ+B8NQmyMsv+76+eeESSrfR/7Mq6svO5VKaoNUY=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/awakened-poe-trade $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/awakened-poe-trade
    cp -a ${appimageContents}/awakened-poe-trade.desktop $out/share/applications/
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/awakened-poe-trade.desktop \
    --replace-fail 'Exec=AppRun' 'Exec=awakened-poe-trade'

    runHook postInstall
  '';

  postFixup = ''
        makeWrapper ${lib.getExe electron} $out/bin/awakened-poe-trade \
    --add-flags $out/share/awakened-poe-trade/resources/app.asar \
    --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        xorg.libXtst
        xorg.libXt
      ]
    }"
  '';

  meta = {
    description = "Path of Exile trading app for price checking";
    homepage = "https://github.com/SnosMe/awakened-poe-trade";
    changelog = "https://github.com/SnosMe/awakened-poe-trade/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nezia ];
    platforms = lib.platforms.linux;
    mainProgram = "awakened-poe-trade";
  };
}
