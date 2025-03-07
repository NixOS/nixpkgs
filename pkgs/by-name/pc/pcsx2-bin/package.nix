{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  # To grab metadata
  pcsx2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pcsx2";
  version = "1.7.5919";

  src = fetchurl {
    url = "https://github.com/PCSX2/pcsx2/releases/download/v${finalAttrs.version}/pcsx2-v${finalAttrs.version}-macos-Qt.tar.xz";
    hash = "sha256-NYgHsYXoIhI2pxqqiMgz5sKBAezEFf4AfEfu5S3diMg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,Applications}
    cp -r "PCSX2-v${finalAttrs.version}.app" $out/Applications/PCSX2.app
    makeWrapper $out/Applications/PCSX2.app/Contents/MacOS/PCSX2 $out/bin/pcsx2-qt
    runHook postInstall
  '';

  meta = {
    inherit (pcsx2.meta) homepage longDescription license changelog downloadPage;
    description = "Playstation 2 emulator; precompiled binary for MacOS, repacked from official website";
    maintainers = with lib.maintainers; [
      matteopacini
    ];
    mainProgram = "pcsx2-qt";
    platforms = lib.systems.inspect.patternLogicalAnd
      lib.systems.inspect.patterns.isDarwin
      lib.systems.inspect.patterns.isx86_64;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
