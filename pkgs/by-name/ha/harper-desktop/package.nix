{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "harper-desktop";
  version = "2.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/Automattic/harper/releases/download/v${finalAttrs.version}/Harper_${finalAttrs.version}_universal.dmg";
    hash = "sha256-qF9FGsSGzf9lD1jXutFgKTGmgKdgSDXKraFKPA3tvJY=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Harper.app "$out/Applications/"

    runHook postInstall
  '';

  # Preserve upstream's signature and notarization, which are required for
  # stable macOS Accessibility permissions.
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privacy-first offline grammar checker for macOS";
    longDescription = ''
      Harper Desktop provides system-wide grammar checking for macOS.
      It requires macOS 14 or later.
      Its built-in automatic updater should be disabled when installed through
      Nix; update Harper Desktop through Nixpkgs instead.
    '';
    homepage = "https://writewithharper.com/desktop";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ tyceherrman ];
    platforms = lib.platforms.darwin;
  };
})
