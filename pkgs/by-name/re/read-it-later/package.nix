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
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "read-it-later";
  version = "0.6.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "read-it-later";
    tag = version;
    hash = "sha256-dXDpZ5CXR/+lJUpQ1EpGgzYC6WKE4Y6CKytvCPrsMNk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-zC9rb+yUWKozTTc3aBOnpTkhqykhQYemnzPtjjKnOdQ=";
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

  passthru.updateScript = nix-update-script { };

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
