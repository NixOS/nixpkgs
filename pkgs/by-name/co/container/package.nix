{
  lib,
  stdenvNoCC,
  fetchurl,
  libarchive,
  xar,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "container";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/apple/container/releases/download/${finalAttrs.version}/container-${finalAttrs.version}-installer-signed.pkg";
    hash = "sha256-E/RfJtqUw1Sty+/h6PdjHn8SbpPF1N1qWlOKpmtPR50=";
  };

  nativeBuildInputs = [
    libarchive
    xar
    installShellFiles
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    xar -xf $src Payload
    bsdtar --extract --file Payload --directory $out

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} --generate-completion-script bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} --generate-completion-script fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} --generate-completion-script zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/container \
      --set-default CONTAINER_INSTALL_ROOT "$out"
    wrapProgram $out/bin/container-apiserver \
      --set-default CONTAINER_INSTALL_ROOT "$out"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Create and run Linux containers using lightweight virtual machines on a Mac";
    homepage = "https://github.com/apple/container";
    changelog = "https://github.com/apple/container/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "container";
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
