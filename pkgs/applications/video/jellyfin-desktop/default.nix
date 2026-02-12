{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  python3,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qtwebchannel,
  qtwebengine,
  mpv-unwrapped,
  mpvqt,
  libcec,
  SDL2,
  libxrandr,
  cacert,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "jellyfin-desktop";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-desktop";
    rev = "v${version}";
    hash = "sha256-ITlYOrMS6COx9kDRSBi4wM6mzL/Q2G5X9GbABwDIOe4=";
    fetchSubmodules = true;
  };
  patches = [
    ./non-fatal-unique-app.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin python3;

  buildInputs = [
    qtbase
    qtdeclarative
    qtwebchannel
    qtwebengine
    mpv-unwrapped

    # input sources
    libcec
    SDL2

    # frame rate switching
    libxrandr
    cacert
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) mpvqt;

  cmakeFlags = [
    "-DCHECK_FOR_UPDATES=OFF"
    # workaround for Qt cmake weirdness
    "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=ON"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DUSE_STATIC_MPVQT=ON"
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "-DUSE_STATIC_MPVQT=OFF";

  qtWrapperArgs = [
    "--set QT_STYLE_OVERRIDE Fusion"
    "--set NIX_SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Desktop.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Desktop.app/Contents/MacOS/Jellyfin Desktop" $out/bin/jellyfindesktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    description = "Jellyfin Desktop Client";
    license = with lib.licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      jojosch
      paumr
    ];
    mainProgram = "jellyfin-desktop";
  };
}
