{
  lib,
  stdenv,
  llvmPackages,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.8.0.9335";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WIBAIzHskEoxijHIIGm+NQ0jfvbnwyES1tiTfnetTxs=";
  };

  patches = [
    # fix undefined references to YAMLConfigReader::loadFromEntry<Enum> at link time when gcc inlines them
    (fetchpatch2 {
      name = "config-define-config-enum-reader-in-header.patch";
      url = "https://github.com/contour-terminal/contour/commit/e63db64edeb8f922bbf50d03c5ea7556407b80ac.patch";
      hash = "sha256-fZVHUnb9azQRoQKyZ4HumSPMlSdIkw3zB8X6lVpe3EQ=";
    })
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-L${lib.getLib llvmPackages.libcxx}/lib";
  };

  # Dependencies are already managed by nix
  cmakeFlags = [
    (lib.cmakeBool "CONTOUR_USE_CPM" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "CONTOUR_MACOS_DEPLOY" false)
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
