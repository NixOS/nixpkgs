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
  version = "0.20.0-Beta";
in
stdenv.mkDerivation {
  pname = "aerospace";

  inherit version;

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
    sha256 = "sha256-bPcVgTPvskit0/LeqmWoOOnlwwyzPoa48P8Vooaqlig=";
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
}
