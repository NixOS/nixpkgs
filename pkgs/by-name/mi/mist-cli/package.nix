{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  xar,
  cpio,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mist-cli";
  version = "2.2";

  src = fetchurl {
    url = "https://github.com/ninxsoft/mist-cli/releases/download/v${finalAttrs.version}/mist-cli.${finalAttrs.version}.pkg";
    hash = "sha256-d+tm37X6JC5r23D8WTsxIkL0RU4U58pJmLermwjOgCE=";
  };

  nativeBuildInputs = [
    installShellFiles
    xar
    cpio
  ];

  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    xar -xf "$src"
    gunzip -dc Payload | cpio -idmv

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -D usr/local/bin/mist "$out/bin/mist"

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mist \
      --bash <($out/bin/mist --generate-completion-script bash) \
      --fish <($out/bin/mist --generate-completion-script fish) \
      --zsh <($out/bin/mist --generate-completion-script zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool that downloads macOS firmwares and installers";
    homepage = "https://github.com/ninxsoft/mist-cli";
    license = lib.licenses.mit;
    mainProgram = "mist";
    maintainers = with lib.maintainers; [ ojsef39 ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
