{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cliprelay";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/geekflyer/cliprelay/releases/download/mac%2Fv${finalAttrs.version}/ClipRelay-${finalAttrs.version}.dmg";
    hash = "sha256-iYhZWH250GHt3jxR5ql3inNJJkpDxqBAGFbIQaOEmJw=";
  };

  nativeBuildInputs = [ _7zz ];
  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "ClipRelay";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r ClipRelay.app $out/Applications

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Seamless clipboard sharing between Android and Mac";
    homepage = "https://cliprelay.org/";
    changelog = "https://github.com/geekflyer/cliprelay/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ myzel394 ];
  };
})
