{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  pkg-config,
  perl,
  ffmpeg,
  alsa-lib,
  gtk3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phira-unwrapped";
  version = "0.7.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TeamFlos";
    repo = "phira";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bn1vRxL4O32Txna3RqafOzXISziDiL//S8NwiIK5c4M=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook # for crate coreaudio-sys
  ];

  buildInputs = [
    ffmpeg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib # for crate alsa-sys
    gtk3 # for crate gtk-sys
  ];

  patches = [
    # use dynamically linked ffmpeg instead of expecting static lib
    ./ffmpeg.patch

    # missing macro from tracing crate
    ./tracing.patch

    # allow using env var to specify location of assets and data
    ./assets.patch
  ];

  cargoHash = "sha256-a+bQ5d9n18jrsgnqygBlMKWlu7KPU5tbQQSXRXE5zWY=";

  # The developer put assets necessary for this test in gitignore, so it cannot run.
  checkFlags = [ "--skip=test_parse_chart" ];

  desktopItems = [
    (makeDesktopItem {
      name = "phira";
      desktopName = "Phira";
      exec = "phira-main";
      icon = "phira";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/icon.png $out/share/icons/hicolor/128x128/apps/phira.png
  '';

  meta = {
    description = "Rhythm game with custom charts and multiplayer";
    homepage = "https://github.com/TeamFlos/phira";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    changelog = "https://github.com/TeamFlos/phira/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    mainProgram = "phira-main";
  };

})
