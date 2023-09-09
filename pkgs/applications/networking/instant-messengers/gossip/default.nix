{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, git
, pkg-config
, ffmpeg
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "gossip";
  version = "unstable-2023-09-07";

  src = fetchFromGitHub {
    owner = "mikedilger";
    repo = "gossip";
    rev = "7b33619a684d0693c59de99b8275c371fabb6bf2";
    hash = "sha256-b2hEaXEfxqB+TzrnuzUS+k6cYomsUvr7iFXAwk4cO+Y=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ecolor-0.22.0" = "sha256-4ZGgtUWIDcgZfMkCdYpUK/pHjdsotVVr/4Aa1W8tNl8=";
      "egui-video-0.1.0" = "sha256-HPnZ0Do2hvWCSGCxv+NZHNVKYOOWufJURcs7w+Ctazo=";
      "ffmpeg-next-6.0.0" = "sha256-k8aGyNdaDs85bb3nTWwmnIyQiMIpC/C6HyFMbWZoMDU=";
      "gossip-relay-picker-0.2.0-unstable" = "sha256-FY3bwwSv4uKqwu6tnrZgwPttS6n731gYR7OJMjpsM7Y=";
      "heed-0.20.0-alpha.4" = "sha256-fnT32ntkZB79AIg7c9+5Bry/Dlc5+VgOaoUyy1JYGMc=";
      "nostr-types-0.7.0-unstable" = "sha256-RfeqVRnE2a2urFvqMp9HDWboHpYYiUgn/QCRj8GVvko=";
      "qrcode-0.12.0" = "sha256-onnoQuMf7faDa9wTGWo688xWbmujgE9RraBialyhyPw=";
      "sdl2-0.35.2" = "sha256-qPId64Y6UkVkZJ+8xK645at5fv3mFcYaiInb0rGUfL4=";
      "speedy-0.8.6" = "sha256-ltJQud1kEYkw7L2sZgPnD/teeXl2+FKgyX9kk2IC2Xg=";
    };
  };

  RUST_BACKTRACE = "1";

  # Compile binary optimized for exact processor with the newest features enabled
  RUSTFLAGS = "-C target-cpu=native --cfg tokio_unstable";

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    rustPlatform.bindgenHook
  ];

  preBuild = ''
    export RUSTUP_TOOLCHAIN=stable
    export CARGO_TARGET_DIR=target
  '';

  buildPhase = ''
    runHook preBuild

    cargo build --release --all-features

    runHook postBuild
  '';

  buildInputs = [
    ffmpeg
    openssl
  ];

  meta = with lib; {
    description = "Desktop client for nostr, an open social media protocol";
    homepage = "https://github.com/mikedilger/gossip";
    downloadPage = "https://github.com/mikedilger/gossip/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.unix;
  };
}
