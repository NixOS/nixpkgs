{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  perl,
  pkg-config,
  gst_all_1,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flare";
  version = "0.20.1";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "flare";
    tag = finalAttrs.version;
    hash = "sha256-DVbN+VUk7K2CBwQ4rOGIJj+KYOlB9TeDUGE+s5docok=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-/3xcouWXUxoVFHV05eD4IEuQbPAn+iFIwB8tP+jJm+4=";
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
  ];

  buildInputs = [
    gtksourceview5
    libadwaita
    libsecret
    libspelling
    openssl
    protobuf

    # To reproduce audio messages
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/flare/-/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Unofficial Signal GTK client";
    mainProgram = "flare";
    homepage = "https://gitlab.com/schmiddi-on-mobile/flare";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
  };
})
