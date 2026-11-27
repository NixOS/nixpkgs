{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  buildGoModule,
  copyDesktopItems,
  desktopToDarwinBundle,
  installShellFiles,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxinerama,
  libxrandr,
  libxxf86vm,
  makeDesktopItem,
  nix-update-script,
  pkg-config,
  sqlite,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gogg";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "habedi";
    repo = "gogg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1XTTYU/8hwY5drvZ34d88tsJpfj3M5ybBVB/ZSYiXts=";
    fetchLFS = true; # JetBrains font
  };

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
    pkg-config
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
    libxxf86vm
  ];

  vendorHash = "sha256-ikrEMyl8uQshhSHMkyXEhp0AXKaboNTQ0wESWG4LN7g=";

  checkFlags = [ "-tags=libsqlite3,integration" ];

  postInstall = ''
    install -Dm644 gui/assets/game-card-svgrepo-com.svg $out/share/icons/hicolor/scalable/apps/gogg.svg
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gogg \
      --bash <($out/bin/gogg completion bash) \
      --fish <($out/bin/gogg completion fish) \
      --zsh <($out/bin/gogg completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  desktopItems = [
    (makeDesktopItem {
      name = "gogg";
      categories = [
        "Network"
        "FileTransfer"
      ];
      comment = finalAttrs.meta.description;
      desktopName = "Gogg";
      exec = "gogg gui";
      icon = "gogg";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  tags = [ "libsqlite3" ];

  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game file downloader for GOG";
    homepage = "https://github.com/habedi/gogg";
    changelog = "https://github.com/habedi/gogg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "gogg";
  };
})
