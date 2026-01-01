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
<<<<<<< HEAD
  libsecret,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "euphonica";
<<<<<<< HEAD
  version = "0.98.0-beta";
=======
  version = "0.96.4-beta";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "htkhiem";
    repo = "euphonica";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-pLs8aLm2CyT8eVtbB8UQj9xSqnjViRxKjuH3A6RErjA=";
=======
    hash = "sha256-iPkqTnC5Gg2hnzQ2Lul5aXF5QhYpHQ1MiilvNiKHFdc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-w6xZQP8QTTPKQgPCX20IvoWErrgWVisEIJKkxwtQHho=";
=======
    hash = "sha256-AISBkWJ0ZZy2HdZCwW6S5DcD09nVJOmglsoevCaD/3g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libsecret
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = {
    description = "MPD client with delusions of grandeur, made with Rust, GTK and Libadwaita";
    homepage = "https://github.com/htkhiem/euphonica";
    license = lib.licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      paperdigits
      aaravrav
    ];
=======
    maintainers = with lib.maintainers; [ paperdigits ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "euphonica";
    platforms = with lib.platforms; linux;
  };
})
