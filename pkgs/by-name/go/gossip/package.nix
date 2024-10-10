{
  cmake,
  darwin,
  fetchFromGitHub,
  ffmpeg,
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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "mikedilger";
    repo = "gossip";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZDpPoGLcI6ModRq0JEcibHerOrPOA3je1uE5yXsLeeg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.26.2" = "sha256-Ih1JbiuUZwK6rYWRSQcP1AJA8NesJJp+EeBtG0azlw0=";
      "egui-video-0.1.0" = "sha256-X75gtYMfD/Ogepe0uEulzxAOY1YpkBW6OPhgovv/uCQ=";
      "ffmpeg-next-7.0.2" = "sha256-LVdaCbPHHEolcrXk9tPxUJiPNCma7qRl53TPKFijhFA=";
      "gossip-relay-picker-0.2.0-unstable" = "sha256-FUhB6ql+H+E6UffWmpwRFzP8N6x+dOX4vdtYdKItjz4=";
      "lightning-0.0.123-beta" = "sha256-gngH0mOC9USzwUGP4bjb1foZAvg6QHuzODv7LG49MsA=";
      "musig2-0.1.0" = "sha256-++1x7uHHR7KEhl8LF3VywooULiTzKeDu3e+0/c/8p9Y=";
      "nip44-0.1.0" = "sha256-u2ALoHQrPVNoX0wjJmQ+BYRzIKsi0G5xPbYjgsNZZ7A=";
      "nostr-types-0.8.0-unstable" = "sha256-HGXPJrI6+HT/oyAV3bELA0LPu4O0DmmJVr0mDtDVfr4=";
      "qrcode-0.12.0" = "sha256-onnoQuMf7faDa9wTGWo688xWbmujgE9RraBialyhyPw=";
      "sdl2-0.36.0" = "sha256-dfXrD9LLBGeYyOLE3PruuGGBZ3WaPBfWlwBqP2pp+NY=";
    };
  };

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
      ffmpeg
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
