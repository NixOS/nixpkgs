{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  cargo,
  capnproto,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gtksourceview5,
  openssl,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "notify-client";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "notify";
    rev = "v${version}";
    hash = "sha256-0p/XIGaawreGHbMRoHNmUEIxgwEgigtrubeJpndHsug=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-hnv4XXsx/kmhH4YUTdTvvxxjbguHBx3TnUKacGwnCTw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    capnproto
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    openssl
    sqlite
  ];

  meta = {
    description = "Ntfy client application to receive everyday's notifications";
    homepage = "https://github.com/ranfdev/Notify";
    license = lib.licenses.gpl3Plus;
    mainProgram = "notify";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
