{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  wrapGAppsHook4,
  desktop-file-utils,
  libxml2,
  libadwaita,
  openssl,
  libsoup_3,
  webkitgtk_6_0,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "read-it-later";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "read-it-later";
    tag = version;
    hash = "sha256-ia65XGJonf/327o7L/862tOh04DOM2oXbKq86cCaVp4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-mn3Jl5XEHYbCCFjLd8TBqtZKEdevH95IWKdgHwAtXk0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    desktop-file-utils
    libxml2.bin # xmllint
  ];

  buildInputs = [
    libadwaita
    openssl
    libsoup_3
    webkitgtk_6_0
    sqlite
  ];

  meta = {
    description = "Simple Wallabag client with basic features to manage articles";
    homepage = "https://gitlab.gnome.org/World/read-it-later";
    changelog = "https://gitlab.gnome.org/World/read-it-later/-/releases/${src.tag}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "read-it-later";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
