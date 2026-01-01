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
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "nixbit";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Vbv6+d0jUNxI7TP06vIey3a7fCzX/jgnNJZ18ntBN2k=";
=======
    hash = "sha256-EaL+ekvvnKZM7fdfuzNz9Ddq7k0HN3ZGW8JpyVyNV9c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "KDE Plasma application to update your NixOS system from a git repository";
    homepage = "https://github.com/pbek/nixbit";
    changelog = "https://github.com/pbek/nixbit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "KDE Plasma application to update your NixOS system from a git repository";
    homepage = "https://github.com/pbek/nixbit";
    changelog = "https://github.com/pbek/nixbit/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pbek ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nixbit";
  };
})
