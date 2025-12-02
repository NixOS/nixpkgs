{
  cmake,
  fetchFromGitHub,
  installShellFiles,
  kdePackages,
  lib,
  libgit2,
  ninja,
  pkg-config,
  qt6,
  stdenv,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixbit";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "nixbit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUnMqrEJp7sg20DIcIIDGMVKghxlo7bp3NB8llfA54k=";
  };

  nativeBuildInputs = [
    cmake
    installShellFiles
    kdePackages.extra-cmake-modules
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    libgit2
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
  ];

  # Install shell completion on Linux (with xvfb-run)
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nixbit \
      --bash <(xvfb-run $out/bin/nixbit --completion-bash) \
      --fish <(xvfb-run $out/bin/nixbit --completion-fish)
  '';

  meta = with lib; {
    description = "KDE Plasma application to update your NixOS system from a git repository";
    homepage = "https://github.com/pbek/nixbit";
    changelog = "https://github.com/pbek/nixbit/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = platforms.linux;
    mainProgram = "nixbit";
  };
})
