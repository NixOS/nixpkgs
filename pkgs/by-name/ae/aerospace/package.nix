{
  fetchzip,
  gitUpdater,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:
let
  appName = "AeroSpace.app";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aerospace";
  version = "0.21.3-Beta";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${finalAttrs.version}/AeroSpace-v${finalAttrs.version}.zip";
    hash = "sha256-JHXtF3IKUbge7z2cMBi4L9IruiByNPCIKugLe4ymvys=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    mv ${appName} $out/Applications
    cp -R bin $out
    mkdir -p $out/share
    runHook postInstall
  '';

  postInstall = ''
    installManPage manpage/*
    installShellCompletion --bash shell-completion/bash/aerospace
    installShellCompletion --fish shell-completion/fish/aerospace.fish
    installShellCompletion --zsh  shell-completion/zsh/_aerospace
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/nikitabobko/AeroSpace.git";
    rev-prefix = "v";
  };

  meta = {
    license = lib.licenses.mit;
    mainProgram = "aerospace";
    homepage = "https://github.com/nikitabobko/AeroSpace";
    description = "i3-like tiling window manager for macOS";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ alexandru0-dev ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
