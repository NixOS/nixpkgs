{
  lib,
  rustPlatform,
  fetchFromGitHub,
  appstream-glib,
  cargo,
  desktop-file-utils,
  glib,
  libadwaita,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  dbus,
  gtk4,
  sqlite,
  openssl,
  xorg,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "furtherance";
  version = "25.3.0";

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
    tag = finalAttrs.version;
    hash = "sha256-LyGO+fbsu16Us0+sK0T6HlGq7EwZWSetd+gCIKKEbkk=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-j/5O40k12rl/gmRc1obo9ImdkZ0Mdrke2PCf6tFCWIo=";

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    pkg-config
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    sqlite
    openssl
    xorg.libXScrnSaver
  ];

  checkFlags = [
    # panicked at src/tests/timer_tests.rs:30:9
    "--skip=tests::timer_tests::timer_tests::test_split_task_input_basic"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Track your time without being tracked";
    mainProgram = "furtherance";
    homepage = "https://github.com/lakoliu/Furtherance";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
  };
})
