{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  node-gyp,
  pkg-config,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,

  # buildInputs
  libsecret,
  ffmpeg,
  yt-dlp,
  electron_43,
  chromium,
}:
let
  electron = electron_43;
in
buildNpmPackage (finalAttrs: {
  pname = "Sharedown";
  version = "20260901092954-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = "Sharedown";
    rev = "225c6e98e3097699c95c31c16b4fc30155eaab6c";
    hash = "sha256-Ephn5lG9mDnx5rngc/XoudGwnuOdvr67hyO2Is+jvG8=";
  };

  npmDepsHash = "sha256-aWymGPE0YW5XmnyNEQw4v8MF7cDI2pxmxlrVJy0hw0k=";

  nativeBuildInputs = [
    copyDesktopItems
    node-gyp
    pkg-config
    makeWrapper
  ];
  dontNpmBuild = true;

  buildInputs = [
    libsecret
  ];

  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    PUPPETEER_SKIP_DOWNLOAD = "1";
  };

  postInstall = ''
    install -Dm0644 build/icon.png $out/share/icons/hicolor/512x512/apps/Sharedown.png

    # Create a launcher wrapper
    makeWrapper ${electron}/bin/electron $out/bin/sharedown \
      --add-flags $out/lib/node_modules/sharedown/app.js \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium \
      --prefix PATH : ${lib.makeBinPath finalAttrs.finalPackage.passthru.wrapperPaths} \
      --add-flags "--no-sandbox"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Sharedown";
      exec = "Sharedown";
      icon = "Sharedown";
      comment = "An Application to save your Sharepoint videos for offline usage.";
      desktopName = "Sharedown";
      categories = [
        # Based upon categories in upstream's package.json
        "AudioVideo"
      ];
    })
  ];

  passthru = {
    wrapperPaths = [
      ffmpeg
      yt-dlp
      chromium
    ];
    updateScript = nix-update-script {
      # Updates are not very frequent, so we wish to track the latest git
      # commit.
      extraArgs = [
        "--version=branch"
      ];
    };
  };

  meta = {
    description = "Application to save your Sharepoint videos for offline usage";
    homepage = "https://github.com/kylon/Sharedown";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "Sharedown";
  };
})
