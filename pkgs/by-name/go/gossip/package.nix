{ cmake
, darwin
, fetchFromGitHub
, ffmpeg
, fontconfig
, git
, lib
, libGL
, libxkbcommon
, makeDesktopItem
, openssl
, pkg-config
, rustPlatform
, stdenv
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "gossip";
  version = "0.9";

  src = fetchFromGitHub {
    hash = "sha256-m0bIpalH12GK7ORcIk+UXwmBORMKXN5AUtdEogtkTRM=";
    owner = "mikedilger";
    repo = "gossip";
    rev = version;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.23.0" = "sha256-Jg1oqxt6YNRbkoKqJoQ4uMhO9ncLUK18BGG0fa+7Bow=";
      "egui-video-0.1.0" = "sha256-3483FErslfafCDVYx5qD6+amSkfVenMGMlEpPDnTT1M=";
      "ffmpeg-next-6.0.0" = "sha256-EkzwR5alMjAubskPDGMP95YqB0CaC/HsKiGVRpKqUOE=";
      "ffmpeg-sys-next-6.0.1" = "sha256-UiVKhrgVkROc25VSawxQymaJ0bAZ/dL0xMQErsP4KUU=";
      "gossip-relay-picker-0.2.0-unstable" = "sha256-3rbjtpxNN168Al/5TM0caRLRd5mxLZun/qVhsGwS7wY=";
      "heed-0.20.0-alpha.6" = "sha256-TFUC6SXNzNXfX18/RHFx7fq7O2le+wKcQl69Uv+CQkY=";
      "nip44-0.1.0" = "sha256-of1bG7JuSdR19nXVTggHRUnyVDMlUrkqioyN237o3Oo=";
      "nostr-types-0.7.0-unstable" = "sha256-B+hOZ4TRDSWgzyAc/yPiTWeU0fFCBPJG1XOHyoXfuQc=";
      "qrcode-0.12.0" = "sha256-onnoQuMf7faDa9wTGWo688xWbmujgE9RraBialyhyPw=";
      "sdl2-0.35.2" = "sha256-qPId64Y6UkVkZJ+8xK645at5fv3mFcYaiInb0rGUfL4=";
      "speedy-0.8.6" = "sha256-ltJQud1kEYkw7L2sZgPnD/teeXl2+FKgyX9kk2IC2Xg=";
    };
  };

  # See https://github.com/mikedilger/gossip/blob/0.9/README.md.
  RUSTFLAGS = "--cfg tokio_unstable";

  # Some users might want to add "rustls-tls(-native)" for Rust TLS instead of OpenSSL.
  buildFeatures = [ "video-ffmpeg" "lang-cjk" ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    fontconfig
    libGL
    libxkbcommon
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
  ] ++ lib.optionals stdenv.isLinux [
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

  postFixup = ''
    patchelf $out/bin/gossip \
      --add-rpath ${lib.makeLibraryPath [ libGL libxkbcommon wayland ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Gossip";
      exec = "gossip";
      icon = "gossip";
      comment = meta.description;
      desktopName = "Gossip";
      categories = [ "Chat" "Network" "InstantMessaging" ];
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
