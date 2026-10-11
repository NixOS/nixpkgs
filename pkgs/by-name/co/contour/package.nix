{
  lib,
  stdenv,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boxed-cpp,
  cairo,
  freetype,
  fontconfig,
  libunicode,
  libutempter,
  termbench-pro,
  qt6,
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
  version = "0.7.0.8982";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sY3qNaYsoYY6Ox5W7F2WHFHId89WbeGJ4fWs2PFQmNk=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-L${lib.getLib llvmPackages.libcxx}/lib";
  };

  # Dependencies are already managed by nix
  cmakeFlags = [
    "-DCONTOUR_USE_CPM=OFF"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCONTOUR_MACOS_DEPLOY=OFF"
  ];

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./link-qtquick.patch
    ./macos-deploy-toggle.patch
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
    cairo
    fontconfig
    freetype
    libunicode
    termbench-pro
    qt6.qtmultimedia
    qt6.qt5compat
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

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    /usr/bin/codesign --force --sign - $out/Applications/contour.app
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
