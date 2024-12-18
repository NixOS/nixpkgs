{
  lib,
  stdenv,
  appstream,
  cargo,
  desktop-file-utils,
  fetchFromGitea,
  gitUpdater,
  gtk4,
  libadwaita,
  libepoxy,
  libglvnd,
  meson,
  mpv,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "delfin";
  version = "0.4.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "avery42";
    repo = "delfin";
    rev = "v${version}";
    hash = "sha256-2ussvPXMX4wGE9N+Zh8KYIjbbqEKkPaNymN1Oqj8w8U=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-JEHiLdEU9QkCxWPoTFVn2c6UDqnRbTG1WPetdsW/N8g=";
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
    maintainers = with maintainers; [
      colinsane
      avery
    ];
    mainProgram = "delfin";
    platforms = platforms.linux;
  };
}
