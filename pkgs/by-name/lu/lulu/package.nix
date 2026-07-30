{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lulu";
  version = "4.3.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/objective-see/LuLu/releases/download/v${finalAttrs.version}/LuLu_${finalAttrs.version}.dmg";
    hash = "sha256-zANmUn8fQSMpX9EzKaCAMaZgr9JWB23asD5gdDZc75M=";
  };

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R LuLu.app "$out/Applications/LuLu.app"

    runHook postInstall
  '';

  dontFixup = true; # Preserve upstream's notarized app bundle and system extension signature.

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free open-source macOS firewall that alerts you to outgoing network connections";
    homepage = "https://objective-see.org/products/lulu.html";
    changelog = "https://github.com/objective-see/LuLu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "LuLu";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
