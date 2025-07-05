{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
  pkg-config,
  autoAddDriverRunpath,
  alsa-lib,
  brotli,
  bzip2,
  celt,
  ffmpeg,
  jack2,
  lame,
  libX11,
  libXi,
  libXrandr,
  libXcursor,
  libdrm,
  libglvnd,
  libogg,
  libpng,
  libtheora,
  libunwind,
  libva,
  libvdpau,
  libxkbcommon,
  openssl,
  openvr,
  pipewire,
  rust-cbindgen,
  soxr,
  vulkan-headers,
  vulkan-loader,
  wayland,
  x264,
  xvidcore,
}:

rustPlatform.buildRustPackage rec {
  pname = "alvr";
  version = "20.14.0";

  src = fetchFromGitHub {
    owner = "alvr-org";
    repo = "ALVR";
    tag = "v${version}";
    fetchSubmodules = true; # TODO devendor openvr
    hash = "sha256-K1E8zeSjaUtJ17C9G+aKNw9bzKUzeezUunZc0MM1Rj4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GeI6YlpTa89W6dYmK/1Hq73R0QX67va9zL1UIyfwcv0=";

  patches = [
    (replaceVars ./fix-finding-libs.patch {
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
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "-Wl,--pop-state"
  ];

  nativeBuildInputs = [
    rust-cbindgen
    pkg-config
    rustPlatform.bindgenHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    alsa-lib
    brotli
    bzip2
    celt
    ffmpeg
    jack2
    lame
    libX11
    libXcursor
    libXi
    libXrandr
    libdrm
    libglvnd
    libogg
    libpng
    libtheora
    libunwind
    libva
    libvdpau
    libxkbcommon
    openssl
    openvr
    pipewire
    soxr
    vulkan-headers
    vulkan-loader
    wayland
    x264
    xvidcore
  ];

  postBuild = ''
    # Build SteamVR driver ("streamer")
    cargo xtask build-streamer --release
  '';

  postInstall = ''
    install -Dm755 ${src}/alvr/xtask/resources/alvr.desktop $out/share/applications/alvr.desktop
    install -Dm644 ${src}/resources/ALVR-Icon.svg $out/share/icons/hicolor/scalable/apps/alvr.svg

    # Install SteamVR driver
    mkdir -p $out/{libexec,lib/alvr,share}
    cp -r ./build/alvr_streamer_linux/lib64/. $out/lib
    cp -r ./build/alvr_streamer_linux/libexec/. $out/libexec
    cp -r ./build/alvr_streamer_linux/share/. $out/share
    ln -s $out/lib $out/lib64
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stream VR games from your PC to your headset via Wi-Fi";
    homepage = "https://github.com/alvr-org/ALVR/";
    changelog = "https://github.com/alvr-org/ALVR/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "alvr_dashboard";
    maintainers = with lib.maintainers; [
      luNeder
      jopejoe1
    ];
    platforms = lib.platforms.linux;
  };
}
