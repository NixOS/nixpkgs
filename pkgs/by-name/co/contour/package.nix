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
  darwin,
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

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./dont-fix-app-bundle.diff
    ./remove-deep-flag-from-codesign.diff
  ];

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  buildInputs = [
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
    darwin.libutil
  ];

  cmakeFlags = [ "-DCONTOUR_QT_VERSION=6" ];

  postInstall = ''
    mkdir -p $out/nix-support $terminfo/share
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications $out/bin
    cp -r $out/contour.app/Contents/Resources/terminfo $terminfo/share
    mv $out/contour.app $out/Applications
    ln -s $out/Applications/contour.app/Contents/MacOS/contour $out/bin/contour
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/share/terminfo $terminfo/share/
    rm -r $out/share/contour
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
