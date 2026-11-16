{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  perl,
  pkg-config,
  gstreamer,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  openssl,
  protobuf,
  libspelling,
  libsecret,
  libadwaita,
  gtksourceview5,
  rustPlatform,
  rustc,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  wrapGAppsHook4,
  aws-lc,
  sqlcipher,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flare";
  version = "0.22.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "flare";
    tag = finalAttrs.version;
    hash = "sha256-yZqILhe/6ii+4zENilFrAISOy4cPCsYoXHoVQhgJndI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-YE5+Eqt8bHUfinScPJtjzwOMZ3W2ddeFEnFA0MFH4nY=";
  };

  nativeBuildInputs = [
    appstream # for appstream-util
    blueprint-compiler
    desktop-file-utils # for update-desktop-database
    meson
    ninja
    perl
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    protobuf
  ];

  buildInputs = [
    aws-lc
    gtksourceview5
    libadwaita
    libsecret
    libspelling
    openssl
    sqlcipher
    sqlite

    # To reproduce audio messages
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ];

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/flare/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Unofficial Signal GTK client";
    mainProgram = "flare";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      marcel
    ];
    platforms = lib.platforms.linux;
  };
})
