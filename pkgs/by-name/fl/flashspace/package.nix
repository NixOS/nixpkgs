{
  fetchzip,
  gitUpdater,
  lib,
  stdenv,
  nix-update-script,
}:

let
  version = "2.3.29";
in
stdenv.mkDerivation {
  pname = "flashspace";

  inherit version;

  src = fetchzip {
    url = "https://github.com/wojciech-kulik/FlashSpace/releases/download/v${version}/FlashSpace.app.zip";
    hash = "sha256-aBqlxIPPhx5GwNowf172Ko10g8RXnN7nIJaD3Zh4TPg=";
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
