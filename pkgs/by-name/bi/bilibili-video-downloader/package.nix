{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook4,
  webkitgtk_4_1,
  openssl,
  ffmpeg,
  cargo-tauri,
  glib-networking,
  makeDesktopItem,
  copyDesktopItems,
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
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-kwORI+j+GSBvuyLdlBmVFYMwyIoYgv2QYhKpBwn+RSE=";
  };

  nativeBuildInputs = [
    pkg-config
    nodejs
    pnpm_11
    pnpmConfigHook
    cargo-tauri.hook
    wrapGAppsHook4
    copyDesktopItems
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

  desktopItems = [
    (makeDesktopItem {
      name = "bilibili-video-downloader";
      exec = "bilibili-video-downloader";
      icon = "bilibili-video-downloader";
      desktopName = "Bilibili Video Downloader";
      comment = finalAttrs.meta.description;
      categories = [ "Video" ];
    })
  ];

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
