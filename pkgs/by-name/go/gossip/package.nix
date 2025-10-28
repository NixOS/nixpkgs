{
  cmake,
  fetchFromGitHub,
  SDL2,
  ffmpeg_6,
  fontconfig,
  git,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  copyDesktopItems,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  wayland,
  wayland-scanner,
  nix-update-script,
  libX11,
  libxcb,
  libXcursor,
  libXi,
  libXrandr,
}:

rustPlatform.buildRustPackage rec {
  pname = "gossip";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "mikedilger";
    repo = "gossip";
    tag = "v${version}";
    hash = "sha256-nv/NMLAka62u0WzvHMEW9XBVXpg9T8bNJiUegS/oj48=";
  };

  cargoHash = "sha256-rE7SErOhl2fcmvLairq+mvdnbDIk1aPo3eYqwRx5kkA=";

  # See https://github.com/mikedilger/gossip/blob/0.9/README.md.
  RUSTFLAGS = "--cfg tokio_unstable";

  # Some users might want to add "rustls-tls(-native)" for Rust TLS instead of OpenSSL.
  buildFeatures = [
    "video-ffmpeg"
    "lang-cjk"
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    rustPlatform.bindgenHook
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    SDL2
    ffmpeg_6
    fontconfig
    libGL
    libxkbcommon
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libX11
    libxcb
    libXcursor
    libXi
    libXrandr
  ];

  # Tests rely on local files, so disable them. (I'm too lazy to patch it.)
  doCheck = false;

  postInstall = ''
    mkdir -p $out/logo
    cp $src/logo/gossip.png $out/logo/gossip.png
    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/logo/gossip.png $out/share/icons/hicolor/128x128/apps/gossip.png
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # We don't want the bundled libraries.
    rm -rf $out/lib

    patchelf $out/bin/gossip \
      --add-rpath ${
        lib.makeLibraryPath [
          SDL2
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Gossip";
      exec = "gossip";
      icon = "gossip";
      comment = meta.description;
      desktopName = "Gossip";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
      ];
      startupWMClass = "gossip";
      mimeTypes = [ "x-scheme-handler/nostr" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for nostr, an open social media protocol";
    downloadPage = "https://github.com/mikedilger/gossip/releases/tag/${version}";
    homepage = "https://github.com/mikedilger/gossip";
    license = lib.licenses.mit;
    mainProgram = "gossip";
    maintainers = with lib.maintainers; [ msanft ];
    platforms = lib.platforms.unix;
  };
}
