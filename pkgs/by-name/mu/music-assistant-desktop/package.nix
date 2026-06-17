{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  fetchYarnDeps,

  # nativeBuildInputs
  cargo-tauri,
  nodejs,
  pkg-config,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
  wrapGAppsHook3,

  # buildInputs
  openssl,
  alsa-lib,
  atk,
  dbus,
  glib-networking,
  libappindicator-gtk3,
  llvmPackages,
  pulseaudio,
  gtk3,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "music-assistant-desktop";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "desktop-app";
    tag = finalAttrs.version;
    hash = "sha256-GL9Cpk6NDhRV0npVXwGjR3Dm0H/uo9cD4ebaI751VLM=";
  };

  # hide update feature
  postPatch = ''
    substituteInPlace src-tauri/src/lib.rs \
      --replace-fail \
        "let update =" \
        "// let update =" \
      --replace-fail \
        "&update," \
        "// &update," \
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-rd0kvUTAi4fOh3hxCY1cmkkLWsxNPxVmPVzB9uEv/8c=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-dOJ5ETRodpnuaI+L2wckNU0XANUcjqzvdqw/cd5sJC4=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    atk
    dbus
    glib-networking
    libappindicator-gtk3
    pulseaudio
    gtk3
    webkitgtk_4_1
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libappindicator-gtk3 ]}"
    )
  '';

  env = {
    # `LIBCLANG_PATH` is needed to build `coreaudio-sys` on darwin
    LIBCLANG_PATH = lib.optionalString stdenv.hostPlatform.isDarwin "${lib.getLib llvmPackages.libclang}/lib";
  };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Official companion desktop app for Music Assistant";
    homepage = "https://github.com/music-assistant/desktop-app";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "music-assistant-companion";
    platforms = lib.platforms.all;
  };
})
