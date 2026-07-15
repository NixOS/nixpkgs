{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openusage";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/robinebers/openusage/releases/download/v${finalAttrs.version}/OpenUsage-${finalAttrs.version}.dmg";
    hash = "sha256-ycKm7kzOM+fv5Jhjv3JrG+oyK3LEOj9Ps7ll2Pz0T9c=";
  };

  unpackCmd = "7zz -snld x $src";

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -r OpenUsage.app $out/Applications/
    ln -s $out/Applications/OpenUsage.app/Contents/MacOS/OpenUsage $out/bin/openusage

    runHook postInstall
  '';

  dontBuild = true;
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Burning through your subscriptions too fast? Paying for stuff you never use? Stop guessing. OpenUsage is free and open source.";
    homepage = "https://www.openusage.ai/";
    changelog = "https://github.com/robinebers/openusage/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      myzel394
      Br1ght0ne
    ];
    mainProgram = "openusage";
  };
})
