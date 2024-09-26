{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pcsx2-bin";
  version = "2.1.136";

  src = fetchurl {
    url = "https://github.com/PCSX2/pcsx2/releases/download/v${finalAttrs.version}/pcsx2-v${finalAttrs.version}-macos-Qt.tar.xz";
    hash = "sha256-TAyOQLBOHOe+EBjirmST7Dmg6F13e/9SACr24/7FVgE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r "PCSX2-v${finalAttrs.version}.app" $out/Applications/PCSX2.app
    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://pcsx2.net";
    description = "Playstation 2 emulator (precompiled binary, repacked from official website)";
    longDescription = ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose is
      to emulate the PS2 hardware, using a combination of MIPS CPU Interpreters,
      Recompilers and a Virtual Machine which manages hardware states and PS2
      system memory. This allows you to play PS2 games on your PC, with many
      additional features and benefits.
    '';
    changelog = "https://github.com/PCSX2/pcsx2/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/PCSX2/pcsx2";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = [ "x86_64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
