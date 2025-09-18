{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
  pipewire,
  sqlite,
  desktop-file-utils,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "euphonica";
  version = "0.96.4-beta";

  src = fetchFromGitHub {
    owner = "htkhiem";
    repo = "euphonica";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iPkqTnC5Gg2hnzQ2Lul5aXF5QhYpHQ1MiilvNiKHFdc=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script {
    # to be dropped once there are stable releases
    extraArgs = [
      "--version=unstable"
    ];
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-AISBkWJ0ZZy2HdZCwW6S5DcD09nVJOmglsoevCaD/3g=";
  };

  mesonBuildType = "release";

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
    pipewire
    sqlite
    libxml2
  ];

  meta = {
    description = "MPD client with delusions of grandeur, made with Rust, GTK and Libadwaita";
    homepage = "https://github.com/htkhiem/euphonica";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "euphonica";
    platforms = with lib.platforms; linux;
  };
})
