{ lib
, stdenv
, appstream
, cargo
, desktop-file-utils
, fetchFromGitea
, gitUpdater
, gtk4
, libadwaita
, libepoxy
, libglvnd
, meson
, mpv
, ninja
, openssl
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "delfin";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "avery42";
    repo = "delfin";
    rev = "v${version}";
    hash = "sha256-1Q3Aywf80CCXxorWSymwxJwMU1I4k7juDoWG5J18AXY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/RZD4b7hrbC1Z5MtHDdib5TFEmxAh9odjNPo4m+FqK4=";
  };

  # upstream pinned the linker to clang/mold through 0.3.0, unnecessarily.
  # remove this patch for version > 0.3.0.
  # see: <https://codeberg.org/avery42/delfin/commit/e6deee77e9a6a6ba2425d1cc88dcbdeb471d1fdc>
  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libglvnd
    libepoxy
    mpv
    openssl
  ];

  mesonFlags = [
    (lib.mesonOption "profile" "release")
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Stream movies and TV shows from Jellyfin";
    homepage = "https://www.delfin.avery.cafe/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ colinsane ];
    mainProgram = "delfin";
    platforms = platforms.linux;
  };
}
