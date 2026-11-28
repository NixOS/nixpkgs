{
  stdenvNoCC,
  lib,
  fetchurl,
  _7zz,
  makeWrapper,
  pname,
  updateScript,
  meta,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;
  version = "26.5.1";
  # Keep update tools from treating the wrapper as the source package.
  pos = __curPos;

  src = fetchurl {
    url = "https://github.com/ProxymanApp/Proxyman/releases/download/${finalAttrs.version}/Proxyman_${finalAttrs.version}.dmg";
    hash = "sha256-MaAsGEpECuwRoT2XGjLl/Ziv9isFjKxOZ1aIdFLEtqA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Proxyman.app $out/Applications
    makeWrapper $out/Applications/Proxyman.app/Contents/MacOS/Proxyman $out/bin/proxyman

    runHook postInstall
  '';

  dontFixup = true;

  passthru = {
    inherit updateScript;
  };

  meta = meta // {
    changelog = "https://proxyman.com/changelog";
    platforms = lib.platforms.darwin;
  };
})
