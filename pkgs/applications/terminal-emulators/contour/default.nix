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
  qtmultimedia,
  qt5compat,
  wrapQtAppsHook,
  pcre,
  boost,
  catch2,
  fmt,
  microsoft-gsl,
  range-v3,
  yaml-cpp,
  ncurses,
  file,
  utmp,
  sigtool,
  nixosTests,
  installShellFiles,
}:

stdenv.mkDerivation (final: {
  pname = "contour";
  version = "0.4.3.6442";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    rev = "v${final.version}";
    hash = "sha256-m3BEhGbyQm07+1/h2IRhooLPDewmSuhRHOMpWPDluiY=";
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
    wrapQtAppsHook
    installShellFiles
  ] ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [
    boxed-cpp
    fontconfig
    freetype
    libunicode
    termbench-pro
    qtmultimedia
    qt5compat
    pcre
    boost
    catch2
    fmt
    microsoft-gsl
    range-v3
    yaml-cpp
  ] ++ lib.optionals stdenv.isLinux [ libutempter ] ++ lib.optionals stdenv.isDarwin [ utmp ];

  cmakeFlags = [ "-DCONTOUR_QT_VERSION=6" ];

  postInstall =
    ''
      mkdir -p $out/nix-support $terminfo/share
    ''
    + lib.optionalString stdenv.isDarwin ''
      mkdir $out/Applications
      installShellCompletion --zsh $out/contour.app/Contents/Resources/shell-integration/shell-integration.zsh
      installShellCompletion --fish $out/contour.app/Contents/Resources/shell-integration/shell-integration.fish
      cp -r $out/contour.app/Contents/Resources/terminfo $terminfo/share
      mv $out/contour.app $out/Applications
      ln -s $out/bin $out/Applications/contour.app/Contents/MacOS
    ''
    + lib.optionalString stdenv.isLinux ''
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
