{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lulu";
  version = "4.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/objective-see/LuLu/releases/download/v${finalAttrs.version}/LuLu_${finalAttrs.version}.dmg";
    hash = "sha256-mPTTQn9Mb8z5aA/tIoeb6Qpa6B6A64YWwddYdVtrtiQ=";
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
    longDescription = ''
      Nearly every application makes network connections. So does malware.
      LuLu is a free, open-source firewall that blocks unknown outgoing
      connections, protecting your privacy and your Mac.
    '';
    homepage = "https://objective-see.org/products/lulu.html";
    downloadPage = "https://objective-see.org/products/lulu.html";
    changelog = "https://github.com/objective-see/LuLu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "lulu";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "lulu";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
      philocalyst
    ];
  };
})
