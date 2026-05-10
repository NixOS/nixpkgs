{
  lib,
  stdenv,
  fetchFromGitHub,
  libzip,
  pkg-config,
  poppler,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kitsas";
  version = "5.11.1";

  src = fetchFromGitHub {
    owner = "artoh";
    repo = "kitupiikki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZU6b7Yl/dE0vk8UfyEVXtpt4ANnuKInvJ/RZYbIZj+Y=";
  };

  nativeBuildInputs = [
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libzip
    poppler
    qt6.qt5compat
    qt6.qtsvg
    qt6.qtwebengine
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  # We use a separate build-dir as otherwise ld seems to get confused between
  # directory and executable name on buildPhase.
  preConfigure = ''
    mkdir build && cd build
  '';

  qmakeFlags = [ "../kitsas/kitsas.pro" ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv kitsas.app $out/Applications
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      install -Dm755 kitsas -t $out/bin
      install -Dm644 ../kitsas.svg -t $out/share/icons/hicolor/scalable/apps
      install -Dm644 ../kitsas.png -t $out/share/icons/hicolor/256x256/apps
      install -Dm644 ../kitsas.desktop -t $out/share/applications
    '';

  meta = {
    changelog = "https://github.com/artoh/kitupiikki/releases/tag/v${finalAttrs.version}";
    description = "Accounting tool suitable for Finnish associations and small business";
    homepage = "https://github.com/artoh/kitupiikki";
    license = lib.licenses.gpl3Plus;
    mainProgram = "kitsas";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
