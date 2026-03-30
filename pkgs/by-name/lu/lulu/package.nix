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

  src = fetchurl {
    url = "https://github.com/objective-see/LuLu/releases/download/v${finalAttrs.version}/LuLu_${finalAttrs.version}.dmg";
    hash = "sha256-zANmUn8fQSMpX9EzKaCAMaZgr9JWB23asD5gdDZc75M=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = "LuLu.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/LuLu.app
    cp -R . $out/Applications/LuLu.app
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free open-source macOS firewall that alerts you to outgoing network connections";
    homepage = "https://objective-see.org/products/lulu.html";
    changelog = "https://github.com/objective-see/LuLu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = lib.platforms.darwin;
  };
})
