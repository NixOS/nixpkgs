{
  stdenv,
  lib,
  fetchFromGitLab,
  nix-update-script,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  grass-sass,
  gtk4,
  gtksourceview5,
  lcms2,
  libadwaita,
  gst_all_1,
  desktop-file-utils,
  appstream-glib,
  openssl,
  pipewire,
  libshumate,
  wrapGAppsHook4,
  blueprint-compiler,
  bubblewrap,
  sqlite,
  xdg-desktop-portal,
  libseccomp,
  glycin-loaders,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fractal";
  version = "13";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    tag = finalAttrs.version;
    hash = "sha256-zIB04OIhMSm6OWHalnLO9Ng87dsvsmYurrro3hKwoYU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-5wI74sKytewbRs0T/IQZFEaRTgJcF6HyDEK0mpjy0LU=";
  };

  patches = [
    # Disable debug symbols in release builds
    # The debug symbols are stripped afterwards anyways, and building with them requires extra memory
    ./disable-debug.patch
  ];

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "target_dir / rust_target / meson.project_name()" \
      "target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  nativeBuildInputs = [
    glib
    grass-sass
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    glib
    gtk4
    gtksourceview5
    lcms2
    libadwaita
    openssl
    pipewire
    libshumate
    sqlite
    xdg-desktop-portal
    libseccomp
    libwebp
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-rs
  ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
      --prefix PATH : "${lib.makeBinPath [ bubblewrap ]}"
    )
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/World/fractal";
    changelog = "https://gitlab.gnome.org/World/fractal/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
    mainProgram = "fractal";
  };
})
