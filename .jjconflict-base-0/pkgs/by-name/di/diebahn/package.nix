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
  libadwaita,
  pango,
  gettext,
  darwin,
  blueprint-compiler,
}:

stdenv.mkDerivation rec {
  pname = "diebahn";
  version = "2.7.1";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "railway";
    rev = version;
    hash = "sha256-SLZJiCkHUS2p7cNk3i3yO2c3tWR4T4ch+zJ1iYEkS6E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${src}";
    inherit src;
    hash = "sha256-XYlRm8yqQr9ZNV7jQeuR8kvqFNudUjJlzE6h9X0zq0Y=";
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

  buildInputs =
    [
      cairo
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreFoundation
        Foundation
        Security
      ]
    );

  # Darwin needs to link against gettext from nixpkgs instead of the one vendored by gettext-sys
  # because the vendored copy does not build with newer versions of clang.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    GETTEXT_BIN_DIR = "${lib.getBin gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  };

  meta = {
    changelog = "https://gitlab.com/schmiddi-on-mobile/railway/-/blob/${src.rev}/CHANGELOG.md";
    description = "Travel with all your train information in one place. Also known as Railway";
    homepage = "https://gitlab.com/schmiddi-on-mobile/railway";
    license = lib.licenses.gpl3Plus;
    mainProgram = "diebahn";
    maintainers = with lib.maintainers; [
      dotlambda
      lilacious
    ];
  };
}
