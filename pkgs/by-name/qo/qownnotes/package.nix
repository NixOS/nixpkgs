{
  lib,
  stdenv,
  fetchurl,
  qt6Packages,
  cmake,
  makeWrapper,
  botan3,
  libgit2,
  pkg-config,
  nixosTests,
  installShellFiles,
  xvfb-run,
  versionCheckHook,
  nix-update-script,
  aspell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "25.11.5";

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${finalAttrs.version}/qownnotes-${finalAttrs.version}.tar.xz";
    hash = "sha256-wXPrYcIAH4X4BP3RfWtVrgHPcc+IWPZcbOFdWdV57Ec=";
  };

  nativeBuildInputs = [
    cmake
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtsvg
    qt6Packages.qtwebsockets
    botan3
    libgit2
    aspell
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6Packages.qtwayland ];

  cmakeFlags = [
    "-DQON_QT6_BUILD=ON"
    "-DBUILD_WITH_SYSTEM_BOTAN=ON"
    "-DBUILD_WITH_LIBGIT2=ON"
    "-DBUILD_WITH_ASPELL=ON"
  ];

  # Install shell completion on Linux (with xvfb-run)
  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      installShellCompletion --cmd ${finalAttrs.appname} \
        --bash <(xvfb-run $out/bin/${finalAttrs.appname} --completion bash) \
        --fish <(xvfb-run $out/bin/${finalAttrs.appname} --completion fish)
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash <(xvfb-run $out/bin/${finalAttrs.appname} --completion bash) \
        --fish <(xvfb-run $out/bin/${finalAttrs.appname} --completion fish)
    ''
    # Install shell completion on macOS
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      installShellCompletion --cmd ${finalAttrs.pname} \
        --bash <($out/bin/${finalAttrs.appname} --completion bash) \
        --fish <($out/bin/${finalAttrs.appname} --completion fish)
    ''
    # Create a lowercase symlink for Linux
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      ln -s $out/bin/${finalAttrs.appname} $out/bin/${finalAttrs.pname}
    ''
    # Rename application for macOS as lowercase binary
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Prevent "same file" error
      mv $out/bin/${finalAttrs.appname} $out/bin/${finalAttrs.pname}.bin
      mv $out/bin/${finalAttrs.pname}.bin $out/bin/${finalAttrs.pname}
    '';

  # Tests QOwnNotes using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.qownnotes;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    changelog = "https://www.qownnotes.org/changelog.html";
    downloadPage = "https://github.com/pbek/QOwnNotes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      pbek
      totoroot
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
    mainProgram = "qownnotes";
  };
})
