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
  apple-sdk_11,
  libutil,
  sigtool,
  nixosTests,
  installShellFiles,
}:

stdenv.mkDerivation (final: {
  pname = "contour";
  version = "0.5.1.7247";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    rev = "v${final.version}";
    hash = "sha256-/vpbyaULemyM3elwaoofvbeeID7jNrmu8X8HlZxWGCk";
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libutempter ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
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

  meta = with lib; {
    description = "Modern C++ Terminal Emulator";
    homepage = "https://github.com/contour-terminal/contour";
    changelog = "https://github.com/contour-terminal/contour/raw/v${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ moni ];
    platforms = platforms.unix;
    mainProgram = "contour";
  };
})
