{
  cmake,
  darwin,
  fetchFromGitHub,
  ffmpeg_6,
  fontconfig,
  git,
  lib,
  libGL,
  libxkbcommon,
  makeDesktopItem,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  wayland,
  wayland-scanner,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "gossip";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "mikedilger";
    repo = "gossip";
    rev = "refs/tags/v${version}";
    hash = "sha256-mPM5HYPEUQ+cGrJ3G/0pmSN4ZQ9SvSNACJRTkgqTAeY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YX/+GHm/pA1VDcQqpTjNlBFpbQgvwZfEl1A3W9K1MaY=";

  # See https://github.com/mikedilger/gossip/blob/0.9/README.md.
  RUSTFLAGS = "--cfg tokio_unstable";

  # Some users might want to add "rustls-tls(-native)" for Rust TLS instead of OpenSSL.
  buildFeatures = [
    "video-ffmpeg"
    "lang-cjk"
  ];

  nativeBuildInputs =
    [
      cmake
      git
      pkg-config
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wayland-scanner
    ];

  buildInputs =
    [
      ffmpeg_6
      fontconfig
      libGL
      libxkbcommon
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.ForceFeedback
      darwin.apple_sdk.frameworks.AVFoundation
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
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
    patchelf $out/bin/gossip \
      --add-rpath ${
        lib.makeLibraryPath [
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
    })
  ];

  meta = with lib; {
    description = "Desktop client for nostr, an open social media protocol";
    downloadPage = "https://github.com/mikedilger/gossip/releases/tag/${version}";
    homepage = "https://github.com/mikedilger/gossip";
    license = licenses.mit;
    mainProgram = "gossip";
    maintainers = with maintainers; [ msanft ];
    platforms = platforms.unix;
  };
}
