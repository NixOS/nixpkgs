{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook4,
  webkitgtk_4_1,
  openssl,
  ffmpeg,
  cargo-tauri,
  glib-networking,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bilibili-video-downloader";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lanyeeee";
    repo = "bilibili-video-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l0+CTu5jl3EzpBFmvqnrS3a7lwaV4zRtZV8GKH5Wwi4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-/+HML4CEJFVGgjLys0lzLIM1QTNBSK4HMJ+oxPS53qQ=";
  };

  nativeBuildInputs = [
    pkg-config
    nodejs
    pnpm_9
    pnpmConfigHook
    cargo-tauri.hook
    wrapGAppsHook4
  ];

  buildInputs = [
    ffmpeg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    webkitgtk_4_1
    glib-networking
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  preBuild = ''
    rm -rf src-tauri/ffmpeg
    mkdir -p src-tauri/ffmpeg
    ln -s ${ffmpeg}/bin/ffmpeg src-tauri/ffmpeg/com.lanyeeee.bilibili-video-downloader-ffmpeg-${stdenv.hostPlatform.config}
    pnpm build
  '';

  cargoHash = "sha256-ICZtSWDWho3UVTMVb4CfAbOSopKXyQEJ/A15BGBLdr0=";

  postInstall = ''
    install -Dm644 src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/bilibili-video-downloader.png
    mkdir -p $out/share/applications
    cat > $out/share/applications/bilibili-video-downloader.desktop <<EOF
    [Desktop Entry]
    Name=Bilibili Video Downloader
    Exec=bilibili-video-downloader
    Icon=bilibili-video-downloader
    Type=Application
    Terminal=false
    Categories=Video;
    EOF
  '';

  meta = {
    description = "Gui tool for downloading Bilibili videos";
    homepage = "https://github.com/lanyeeee/bilibili-video-downloader";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rxda
    ];
    mainProgram = "bilibili-video-downloader";
  };
})
