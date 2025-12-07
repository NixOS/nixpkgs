{
  lib,
  symlinkJoin,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  gitUpdater,

  # buildInputs
  atk,
  cef-binary,
  gtk3,
  libayatana-appindicator,
  libxkbcommon,
  mpv,
  openssl,

  # nativeBuildInputs
  wrapGAppsHook4,
  makeBinaryWrapper,
  pkg-config,

  # Wrapper
  libGL,
  nodejs,
}:

let
  # Follow upstream
  # https://github.com/Stremio/stremio-linux-shell/blob/v1.0.0-beta.13/flatpak/com.stremio.Stremio.Devel.json#L150
  cefPinned = cef-binary.override {
    version = "138.0.21";
    gitRevision = "54811fe";
    chromiumVersion = "138.0.7204.101";

    srcHashes = {
      aarch64-linux = ""; # TODO: Add when available
      x86_64-linux = "sha256-Kob/5lPdZc9JIPxzqiJXNSMaxLuAvNQKdd/AZDiXvNI=";
    };
  };

  # Stremio expects CEF files in a specific layout
  cefPath = symlinkJoin {
    name = "stremio-cef-target";
    paths = [
      "${cefPinned}/Resources"
      "${cefPinned}/Release"
    ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  version = "1.0.0-beta.13";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1f9IBNo5gxpSqTSIf8QuQOlf+sfRhohOmQTLRbX/OU8=";
  };

  cargoHash = "sha256-wx5oF4uF9UMtKzfGxZKsy6mVjYaRD40dLuvaRtz8yE4=";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace $cargoDepsCopy/xkbcommon-dl-*/src/lib.rs \
      --replace-fail "libxkbcommon.so.0" "${libxkbcommon}/lib/libxkbcommon.so.0"
    substituteInPlace $cargoDepsCopy/xkbcommon-dl-*/src/x11.rs \
      --replace-fail "libxkbcommon-x11.so.0" "${libxkbcommon}/lib/libxkbcommon-x11.so.0"
  '';

  # Don't download CEF during build
  buildFeatures = [ "offline-build" ];

  buildInputs = [
    atk
    cefPath
    gtk3
    libayatana-appindicator
    libxkbcommon
    mpv
    openssl
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    makeBinaryWrapper
    pkg-config
  ];

  env.CEF_PATH = "${cefPath}";

  postInstall = ''
    mkdir -p $out/share/applications
    cp data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    cp data/server.js $out/bin/server.js
    mv $out/bin/stremio-linux-shell $out/bin/stremio
  '';

  # Node.js is required to run `server.js`
  # Add to `gappsWrapperArgs` to avoid two layers of wrapping.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}"
    )
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      unfree
    ];
    maintainers = with lib.maintainers; [ thunze ];
    platforms = lib.platforms.linux;
    mainProgram = "stremio";
  };
})
