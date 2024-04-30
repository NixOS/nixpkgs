{
  lib,
  rustPlatform,
  fetchFromGitHub,
  substituteAll,
  pkg-config,
  alsa-lib,
  brotli,
  bzip2,
  ffmpeg,
  jack2,
  lame,
  libX11,
  libXrandr,
  libdrm,
  libogg,
  libpng,
  libtheora,
  libunwind,
  libva,
  libvdpau,
  libxkbcommon,
  openssl,
  soxr,
  vulkan-headers,
  vulkan-loader,
  wayland,
  x264,
  xvidcore,
}:

rustPlatform.buildRustPackage rec {
  pname = "alvr";
  version = "20.7.1";

  src = fetchFromGitHub {
    owner = "alvr-org";
    repo = "ALVR";
    rev = "refs/tags/v${version}";
    hash = "sha256-znIRSax4thuBIpxW8BNqJSUYgIeY8g06qA9P/i8awvQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "openxr-0.17.1" = "sha256-fG/JEqQQwKP5aerANAt5OeYYDZxcvUKCCaVdWRqHBPU=";
      "settings-schema-0.2.0" = "sha256-luEdAKDTq76dMeo5kA+QDTHpRMFUg3n0qvyQ7DkId0k=";
    };
  };

  patches = [
    (substituteAll {
      src = ./fix-finding-libs.patch;
      ffmpeg = lib.getDev ffmpeg;
      x264 = lib.getDev x264;
    })
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-lbrotlicommon"
      "-lbrotlidec"
      "-lcrypto"
      "-lpng"
      "-lssl"
    ];
  };

  RUSTFLAGS = map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lwayland-client"
      "-lxkbcommon"
      "-Wl,--pop-state"
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    brotli
    bzip2
    ffmpeg
    jack2
    lame
    libX11
    libXrandr
    libdrm
    libogg
    libpng
    libtheora
    libunwind
    libva
    libvdpau
    libxkbcommon
    openssl
    soxr
    vulkan-headers
    vulkan-loader
    wayland
    x264
    xvidcore
  ];

  postInstall = ''
    install -Dm755 ${src}/alvr/xtask/resources/alvr.desktop $out/share/applications/alvr.desktop
    install -Dm644 ${src}/resources/alvr.png $out/share/icons/hicolor/256x256/apps/alvr.png
  '';

  meta = with lib; {
    description = "Stream VR games from your PC to your headset via Wi-Fi";
    homepage = "https://github.com/alvr-org/ALVR/";
    changelog = "https://github.com/alvr-org/ALVR/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "alvr_dashboard";
    maintainers = with maintainers; [ passivelemon ];
    platforms = platforms.linux;
  };
}
