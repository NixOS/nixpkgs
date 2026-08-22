{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  unzip,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "davit";
  version = "0.1.19";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/wouterdebie/davit/releases/download/v${finalAttrs.version}/Davit-${finalAttrs.version}.zip";
    hash = "sha256-XWij8/6/3TebhWBIleiec+xEZ6ma6Yvlnw5JeTJJ0HQ=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Davit.app $out/Applications/
    makeWrapper $out/Applications/Davit.app/Contents/MacOS/Davit $out/bin/davit

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native macOS UI for Apple's container platform";
    homepage = "https://github.com/wouterdebie/davit";
    changelog = "https://github.com/wouterdebie/davit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "davit";
  };
})
