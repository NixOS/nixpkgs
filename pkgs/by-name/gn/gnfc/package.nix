{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnfc";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "manut";
    repo = "gnfc";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-bJn8ssWOXwvPaIHwSbJOWnnOEeYIyYKWMX80/TaktBM=";
  };

  strictDeps = true;

  # Upstream does not ship a Cargo.lock, so it is generated with
  # `cargo generate-lockfile` and kept in nixpkgs.
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # The meson build only builds the cargo release profile when the meson
  # buildtype is "release".
  mesonBuildType = "release";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = {
    description = "NFC tag reader/writer using neard D-Bus interface";
    homepage = "https://salsa.debian.org/manut/gnfc";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "gnfc";
    platforms = lib.platforms.linux;
  };
})
