{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opentabletdriver-bin";
  version = "0.6.7";

  src = fetchurl {
    url = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${finalAttrs.version}/OpenTabletDriver-${finalAttrs.version}_osx-x64.tar.gz";
    hash = "sha256-xLDZ6yrujue+EtDfgPlh6gpyNfVLX1miti76m57EkQ4=";
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    mkdir -p $out/Applications
    cp -r OpenTabletDriver.app $out/Applications/
    makeWrapper $out/Applications/OpenTabletDriver.app/Contents/MacOS/OpenTabletDriver.Console $out/bin/${finalAttrs.meta.mainProgram}
    makeWrapper $out/Applications/OpenTabletDriver.app/Contents/MacOS/OpenTabletDriver.Daemon $out/bin/otd-daemon
    makeWrapper $out/Applications/OpenTabletDriver.app/Contents/MacOS/OpenTabletDriver.UX.MacOS $out/bin/otd-gui
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v${finalAttrs.version}";
    description = "Open source, cross-platform, user-mode tablet driver";
    homepage = "https://opentabletdriver.net/";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "otd";
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
