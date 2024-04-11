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
  version = "0.4.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "avery42";
    repo = "delfin";
    rev = "v${version}";
    hash = "sha256-7GHwwwFibmwBcrlC2zSpEUZ2dca14wZFU6PJWjincPQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-zlecw6230AC/+y537iEhJU+BgWRs2WCFP0AIcxchZBA=";
  };

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
