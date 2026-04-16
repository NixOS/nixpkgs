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
  makeBinaryWrapper,
  pkg-config,
  wrapGAppsHook4,

  # Wrapper
  addDriverRunpath,
  libGL,
  nodejs,
}:

let
  # Stremio expects CEF files in a specific layout
  cef = symlinkJoin {
    name = "stremio-linux-shell-cef";
    paths = [
      "${cef-binary}/Resources"
      "${cef-binary}/Release"
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

  patches = [
    # Chromium 142 stopped allowing local network access by default, which
    # breaks the app's ability to communicate with the Stremio server.
    ./allow-local-network-access.patch

    # GLchar is u8 on aarch64
    # Upstream PR: https://github.com/Stremio/stremio-linux-shell/pull/40
    ./fix-getshaderinfolog-call.patch

    # Patch server.js path so that we don't have to install it in $out/bin
    ./better-server-path.patch
  ];

  postPatch = ''
    substituteInPlace src/config.rs \
      --replace-fail "@serverjs@" "${placeholder "out"}/share/stremio/server.js"

    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace $cargoDepsCopy/*/xkbcommon-dl-*/src/lib.rs \
      --replace-fail "libxkbcommon.so.0" "${libxkbcommon}/lib/libxkbcommon.so.0"
    substituteInPlace $cargoDepsCopy/*/xkbcommon-dl-*/src/x11.rs \
      --replace-fail "libxkbcommon-x11.so.0" "${libxkbcommon}/lib/libxkbcommon-x11.so.0"
  '';

  # Don't download CEF during build
  buildFeatures = [ "offline-build" ];

  buildInputs = [
    atk
    cef
    gtk3
    libayatana-appindicator
    libxkbcommon
    mpv
    openssl
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook4
  ];

  env.CEF_PATH = "${cef}";

  postInstall = ''
    mkdir -p $out/share/applications
    cp data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    mkdir -p $out/share/stremio
    cp data/server.js $out/share/stremio/server.js

    mv $out/bin/stremio-linux-shell $out/bin/stremio
  '';

  # Node.js is required to run `server.js`
  # Add to `gappsWrapperArgs` to avoid two layers of wrapping.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}"
    )
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit cef;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      unfree
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      obfuscatedCode # server.js
    ];
    maintainers = with lib.maintainers; [ thunze ];
    platforms = lib.platforms.linux;
    mainProgram = "stremio";
  };
})
