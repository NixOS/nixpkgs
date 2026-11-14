{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  python3,
  kdePackages,
  mpv-unwrapped,
  libcec,
  SDL2,
  libxrandr,
  cacert,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jellyfin-desktop";
  version = "2.1.0-pre1-unstable-2026-11-07";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-desktop";
    rev = "3fa72e5df57ab52c907b65bb42f2a05b7ae25cd6";
    hash = "sha256-vxWqt9Xa/cggdfZMqzHhbQ0TTXfKaZ6jlHx8Lcg2rQQ=";
    fetchSubmodules = true;
  };
  patches = [
    ./non-fatal-unique-app.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin python3;

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtwebchannel
    kdePackages.qtwebengine
    mpv-unwrapped

    # input sources
    libcec
    SDL2

    # frame rate switching
    libxrandr
    cacert
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) kdePackages.mpvqt;

  cmakeFlags = [
    "-DCHECK_FOR_UPDATES=OFF"
    # workaround for Qt cmake weirdness
    "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=ON"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DUSE_STATIC_MPVQT=ON"
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "-DUSE_STATIC_MPVQT=OFF";

  qtWrapperArgs = [
    "--set"
    "QT_STYLE_OVERRIDE"
    "Fusion"

    "--set"
    "NIX_SSL_CERT_FILE"
    "${cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Desktop.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Desktop.app/Contents/MacOS/Jellyfin Desktop" $out/bin/jellyfin-desktop
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

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
    ];
    maintainers = with lib.maintainers; [
      jojosch
      paumr
      irgolic
    ];
    mainProgram = "jellyfin-desktop";
  };
})
