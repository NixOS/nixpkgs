{
  lib,

  SDL2,
  cmake,
  fetchFromGitHub,
  fribidi,
  kdePackages,
  libGL,
  libX11,
  libXrandr,
  libass,
  libsysprof-capture,
  libunwind,
  libvdpau,
  mpv,
  ninja,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  qttools,
  qtwayland,
  qtwebchannel,
  qtwebengine,
  substitute,
  stdenv,
  withDbus ? stdenv.hostPlatform.isLinux,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-media-player";
  version = "6c7a37d5e61da281e4cc4b1d51892f785e9566ad";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-media-player";
    rev = "${version}";
    sha256 = "sha256-AHYeLxlv+YH1sD6QebEn3qLu//aFeG8wqdQ35W6oZ1s=";
  };

  patches = [
    # fix the location of the jellyfin-web path
    #./fix-web-path.patch
    # disable update notifications since the end user can't simply download the release artifacts to update
    ./disable-update-notifications.patch
    # Don’t copy the dylibs and frameworks into the app bundle
    (substitute {
      src = ./darwin-use-store-frameworks.patch;
      substitutions = [
        "--subst-var-by"
        "qtwebengine"
        (lib.getLib qtwebengine)
      ];
    })
  ];

  buildInputs = [
    SDL2
    libass
    libGL
    libX11
    libXrandr
    libvdpau
    mpv
    kdePackages.mpvqt
    qtbase
    qttools
    qtdeclarative
    qtwebchannel
    qtwebengine
    libsysprof-capture
    libunwind
    fribidi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DQTROOT=${qtbase}"
    "-GNinja"
    "-DUSE_STATIC_MPVQT=OFF"
    "-DQt6_DIR=${qtbase}/lib/cmake/Qt6"
  ]
  ++ lib.optionals (!withDbus) [
    "-DLINUX_X11POWER=ON"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Media Player.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Media Player.app/Contents/MacOS/Jellyfin Media Player" $out/bin/jellyfinmediaplayer
  '';

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client based on Plex Media Player";
    license = with licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [
      jojosch
      kranzes
      paumr
    ];
    mainProgram = "jellyfinmediaplayer";
  };
}
