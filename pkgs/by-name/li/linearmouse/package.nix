{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "linearmouse";

  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/linearmouse/linearmouse/releases/download/v${finalAttrs.version}/LinearMouse.dmg";
    hash = "sha256-r/UPPIGM7VpOIqYXTIcuMiN5fUMmP+ZH1/lV+b4Pzzw=";
  };

  # linearmouse is apfs for some reason and undmg doesnt support that lol
  nativeBuildInputs = [ _7zz ];
  unpackCmd = "7zz x $curSrc";
  sourceRoot = "LinearMouse.app";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/LinearMouse.app
    cp -R . $out/Applications/LinearMouse.app/

    runHook postInstall
  '';

  meta = {
    description = "Mouse and trackpad utility for Mac";
    downloadPage = "https://github.com/linearmouse/linearmouse/releases";
    homepage = "https://github.com/linearmouse/linearmouse";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ paige ];
  };
})
