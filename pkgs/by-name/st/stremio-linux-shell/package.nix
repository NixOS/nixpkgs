{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,

  # nativeBuildInputs
  pkg-config,
  wrapGAppsHook4,

  # buildInputs
  bashNonInteractive,
  glib-networking,
  gtk4,
  libadwaita,
  libepoxy,
  libsoup_3,
  mpv,
  webkitgtk_6_0,

  # Wrapper
  addDriverRunpath,
  nodejs,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stremio-linux-shell";
  version = "1.1.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jo+9KDX/a46jPTmYhiFNgp5fDKhoAsML/+m7u3ituEQ=";
  };

  cargoHash = "sha256-hZ9neZD+aB7bth4UTsWJXIKGSbo/c3wZRtfOIp7LvwY=";

  patches = [
    ./out-path.patch
  ];

  postPatch = ''
    substituteInPlace data/com.stremio.Stremio.service data/stremio.sh build.rs \
      --subst-var out
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    bashNonInteractive
    glib-networking
    gtk4
    libadwaita
    libepoxy
    libsoup_3
    mpv
    webkitgtk_6_0
  ];

  postInstall = ''
    install -Dm644 data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg
    install -Dm644 data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    install -Dm644 data/com.stremio.Stremio.metainfo.xml $out/share/metainfo/com.stremio.Stremio.metainfo.xml
    install -Dm644 data/com.stremio.Stremio.service $out/share/dbus-1/services/com.stremio.Stremio.service
    install -Dm644 data/server.js $out/libexec/stremio/server.js
    install -Dm755 data/stremio.sh $out/bin/stremio
    install -Dm644 LICENSE $out/share/licenses/stremio/LICENSE

    mv $out/bin/stremio-linux-shell $out/libexec/stremio/stremio
  '';

  # Avoid also wrapping `$out/libexec/stremio/stremio`
  dontWrapGApps = true;

  # Node.js is required to run `server.js`
  # Add to `wrapGApp` arguments to avoid two layers of wrapping.
  preFixup = ''
    wrapGApp $out/bin/stremio \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ addDriverRunpath.driverLink ]}" \
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}" \
      --prefix ANV_DEBUG : "video-decode,video-encode" \
      --prefix LC_NUMERIC : "C" \
      --prefix SERVER_PATH : "$out/libexec/stremio/server.js"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
    };
  };

  meta = {
    description = "Client for Stremio on Linux";
    homepage = "https://www.stremio.com/";
    downloadPage = "https://github.com/Stremio/stremio-linux-shell";
    changelog = "https://github.com/Stremio/stremio-linux-shell/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        gpl3Only
        unfree # server.js
      ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      obfuscatedCode # server.js
    ];
    maintainers = with lib.maintainers; [
      thunze
      fazzi
    ];
    platforms = lib.platforms.linux;
    mainProgram = "stremio";
  };
})
