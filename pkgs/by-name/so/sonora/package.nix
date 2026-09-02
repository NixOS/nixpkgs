{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  alsa-lib,
  alsa-plugins,
  pipewire,
  symlinkJoin,
  dbus,
  fontconfig,
  freetype,
  sqlite,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libxcb,
  libx11,
  libxcursor,
  libxi,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sonora";
  version = "0.30.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nolight132";
    repo = "sonora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PcYHHbjk4KLukNtw122Nd0Q7Z8tKi4GcbAcYtzAWWII=";
  };

  cargoHash = "sha256-sb9em6fwA85Lr77LCo6lz60hxiPsSxIJ0pkffr7V0A4=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    freetype
    sqlite
    vulkan-loader
    wayland
    libxkbcommon
    libxcb
    libx11
    libxcursor
    libxi
  ];

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";

  cargoBuildFlags = [ "--package=sonora" ];

  doCheck = false;

  postInstall = ''
    install -Dm644 assets/linux/sonora.desktop $out/share/applications/sonora.desktop
    install -Dm644 assets/linux/sonora.svg $out/share/icons/hicolor/scalable/apps/sonora.svg
    for icon in assets/linux/icons/hicolor/*/apps/sonora.png; do
      size="$(basename "$(dirname "$(dirname "$icon")")")"
      install -Dm644 "$icon" "$out/share/icons/hicolor/$size/apps/sonora.png"
    done
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        wayland
        libxkbcommon
      ]
    } $out/bin/sonora
    wrapProgram $out/bin/sonora \
      --set ALSA_PLUGIN_DIR ${finalAttrs.passthru.alsaPluginDirectory}
  '';

  passthru = {
    updateScript = ./update.sh;
    alsaPluginDirectory = symlinkJoin {
      name = "sonora-alsa-plugins";
      paths = [
        "${pipewire}/lib/alsa-lib"
        "${alsa-plugins}/lib/alsa-lib"
      ];
    };
  };

  meta = {
    description = "Native music streaming client for Spotify, YouTube Music, and local files";
    homepage = "https://github.com/nolight132/sonora";
    changelog = "https://github.com/nolight132/sonora/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      ofl
      isc
      mit
      asl20
      cc-by-40
      cc0
    ];
    maintainers = with lib.maintainers; [
      Ra77a3l3-jar
      nolight132
    ];
    mainProgram = "sonora";
    platforms = lib.platforms.linux;
  };
})
