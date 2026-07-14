{
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  glib,
  gtk4,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustc,
  rustPlatform,
  sqlite,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bobby";
  version = "50.0.2";

  src = fetchFromGitHub {
    owner = "hbons";
    repo = "bobby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/N7CmzPwUdGkHIZujCGW3LvsGM6DdXrcm2kH6XlVGDA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TT3ceAy44sfyKZ7wmH3C4nj5TyfiJlu4vBWAaGs+pGg=";
  };

  buildInputs = [
    glib
    gtk4
    libadwaita
    sqlite
  ];

  # favor sqlite from nixpkgs instead of a vendored variant in rusqlite
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', features = ["bundled"]' ""
  '';

  nativeBuildInputs = [
    cargo
    desktop-file-utils # for `update-desktop-database`
    gtk4 # for `gtk-update-icon-cache`
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4 # fix error: GLib-GIO-ERROR **: No GSettings schemas are installed on the system
  ];

  mesonCheckFlags = [
    "--print-errorlogs"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    changelog = "https://github.com/hbons/Bobby/blob/${finalAttrs.src.tag}/data/studio.planetpeanut.Bobby.metainfo.xml";
    description = "Browse SQLite files";
    donationPage = "https://planetpeanut.studio/sponsors";
    homepage = "https://apps.gnome.org/Bobby/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aiyion
    ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "bobby";
  };
})
