{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  nix-update-script,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kiwix-apple";
  version = "3.13.0";

  src = fetchurl {
    url = "https://download.kiwix.org/release/kiwix-macos/kiwix-macos_${finalAttrs.version}.dmg";
    hash = "sha256-f9Un5ufiwwDiMesdw2dtnHWLM4ZtGMnFcGMuR3aIvHs=";
  };

  sourceRoot = ".";

  strictDeps = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    undmg
  ];

  postInstall = ''
    mkdir -p $out/Applications
    cp -r Kiwix.app $out/Applications
    makeWrapper $out/Applications/Kiwix.app/Contents/MacOS/Kiwix $out/bin/${finalAttrs.meta.mainProgram}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url=https://github.com/kiwix/kiwix-apple"
      "--version-regex=(.*\\..*\\..*)" # matches arbitrary tags otherwise
    ];
  };

  meta = {
    changelog = "https://github.com/kiwix/kiwix-apple/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Offline reader for Web content";
    downloadPage = "https://get.kiwix.org/en/solutions/applications/kiwix-reader/";
    homepage = "https://get.kiwix.org/en/solutions/applications/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kiwix";
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
