{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "palmier-pro";
  version = "0.4.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/palmier-io/palmier-pro/releases/download/v${finalAttrs.version}/PalmierPro.dmg";
    hash = "sha256-m97i2EsEYjJ0TAu+FUAFMNRAvggVbzUr1+l2EAzz9do=";
  };

  sourceRoot = ".";

  unpackCmd = ''
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    finish() {
      /usr/bin/hdiutil detach "$mnt" -force
      rm -rf "$mnt"
    }
    trap finish EXIT
    /usr/bin/hdiutil attach -nobrowse -mountpoint "$mnt" "$curSrc"
    cp -a "$mnt"/PalmierPro.app "$PWD"/
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r PalmierPro.app $out/Applications
    makeWrapper $out/Applications/PalmierPro.app/Contents/MacOS/PalmierPro $out/bin/palmier-pro
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS video editor built for AI";
    homepage = "https://www.palmier.io/";
    changelog = "https://github.com/palmier-io/palmier-pro/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = [ "aarch64-darwin" ];
    mainProgram = "palmier-pro";
  };
})
