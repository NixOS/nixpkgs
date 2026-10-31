{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  makeWrapper,
  openssl,
  zstd,
  alsa-lib,
  freetype,
  fontconfig,
  wayland,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
}:

let
  runtimeLibs = [
    wayland
    libxkbcommon
    libGL
    fontconfig
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "music-player-desktop";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tsirysndr";
    repo = "music-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZcLDw9+bH3Iu3zdIyFdlIeAQfsnySDnfeJoHr2yViuA=";
  };

  cargoHash = "sha256-W5VWyXDleZYm+w0yDRTHfRuZjvA2gsXn1eE0UQYg77A=";

  cargoBuildFlags = [
    "--package"
    "music-player-desktop"
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    makeWrapper
  ];

  buildInputs = [
    openssl
    zstd
    alsa-lib
    freetype
  ]
  ++ runtimeLibs;

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  doCheck = false;

  postInstall = ''
    install -Dm644 dist/music-player.desktop \
      $out/share/applications/music-player.desktop
    install -Dm644 desktop/assets/icon.svg \
      $out/share/icons/hicolor/scalable/apps/music-player.svg
  '';

  postFixup = ''
    wrapProgram $out/bin/music-player-desktop \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs}
  '';

  meta = {
    description = "Desktop client (Slint) for the music-player daemon";
    homepage = "https://github.com/tsirysndr/music-player";
    changelog = "https://github.com/tsirysndr/music-player/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tsirysndr ];
    mainProgram = "music-player-desktop";
    platforms = lib.platforms.linux;
  };
})
