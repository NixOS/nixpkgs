{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  openssl,
  libadwaita,
  pango,
  gettext,
  blueprint-compiler,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "diebahn";
  version = "2.9.3";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "railway";
    tag = version;
    hash = "sha256-Bs+qn6QZnY37Kk7Xl4QE9k41T2W8gIvtcP4I5qLERNI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ijbVyVC0Vq5Olo3odzRv078CosAiIZ6KJNx0Gv5YunI=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
  ];

  # Darwin needs to link against gettext from nixpkgs instead of the one vendored by gettext-sys
  # because the vendored copy does not build with newer versions of clang.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/railway/-/blob/${src.tag}/CHANGELOG.md";
    description = "Travel with all your train information in one place. Also known as Railway";
    homepage = "https://gitlab.com/schmiddi-on-mobile/railway";
    license = lib.licenses.gpl3Plus;
    mainProgram = "diebahn";
    maintainers = with lib.maintainers; [
      dotlambda
      lilacious
      cholli
    ];
    teams = [ lib.teams.gnome-circle ];
  };
}
