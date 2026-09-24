{
  fetchzip,
  lib,
  stdenv,
  nix-update-script,
}:

let
  version = "3.3.39";
in
stdenv.mkDerivation {
  pname = "flashspace";

  inherit version;

  src = fetchzip {
    url = "https://github.com/wojciech-kulik/FlashSpace/releases/download/v${version}/FlashSpace.app.zip";
    hash = "sha256-/mgdeRxaxq+oIjbbaxCSExHxyYqqWl80+6jPzPIhT4M=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications/FlashSpace.app $out/bin
    mv Contents $out/Applications/FlashSpace.app
    ln -s ../Applications/Flashspace.app/Contents/Resources/flashspace $out/bin/flashspace
    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };
  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/wojciech-kulik/FlashSpace";
    changelog = "https://github.com/wojciech-kulik/FlashSpace/releases/tag/v${version}";
    description = "Blazingly fast virtual workspace manager for macOS";
    platforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.marcusramberg ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
