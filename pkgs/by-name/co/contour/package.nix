{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boxed-cpp,
  freetype,
  fontconfig,
  libunicode,
  libutempter,
  termbench-pro,
  qt6,
  pcre,
  boost,
  catch2_3,
  fmt,
  microsoft-gsl,
  range-v3,
  yaml-cpp,
  ncurses,
  file,
  libutil,
  sigtool,
  nixosTests,
  installShellFiles,
  reflection-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "contour";
  version = "0.6.1.7494";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jgasZhdcJ+UF3VIl8HLcxBayvbA/dkaOG8UtANRgeP4=";
  };

  patches = [ ./dont-fix-app-bundle.diff ];

  outputs = [
    "out"
    "terminfo"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ncurses
    file
    qt6.wrapQtAppsHook
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sigtool ];

  buildInputs =
    [
      boxed-cpp
      fontconfig
      freetype
      libunicode
      termbench-pro
      qt6.qtmultimedia
      qt6.qt5compat
      pcre
      boost
      catch2_3
      fmt
      microsoft-gsl
      range-v3
      yaml-cpp
      reflection-cpp
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libutempter ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libutil
    ];

  cmakeFlags = [ "-DCONTOUR_QT_VERSION=6" ];

  postInstall =
    ''
      mkdir -p $out/nix-support $terminfo/share
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir $out/Applications
      installShellCompletion --zsh $out/contour.app/Contents/Resources/shell-integration/shell-integration.zsh
      installShellCompletion --fish $out/contour.app/Contents/Resources/shell-integration/shell-integration.fish
      cp -r $out/contour.app/Contents/Resources/terminfo $terminfo/share
      mv $out/contour.app $out/Applications
      ln -s $out/bin $out/Applications/contour.app/Contents/MacOS
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mv $out/share/terminfo $terminfo/share/
      installShellCompletion --zsh $out/share/contour/shell-integration/shell-integration.zsh
      installShellCompletion --fish $out/share/contour/shell-integration/shell-integration.fish
    ''
    + ''
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    '';

  passthru.tests.test = nixosTests.terminal-emulators.contour;

  meta = {
    description = "Modern C++ Terminal Emulator";
    homepage = "https://github.com/contour-terminal/contour";
    changelog = "https://github.com/contour-terminal/contour/raw/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moni ];
    platforms = lib.platforms.unix;
    mainProgram = "contour";
  };
})
