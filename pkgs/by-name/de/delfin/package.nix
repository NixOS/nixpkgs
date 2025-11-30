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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-zZc2+0oskptpWZE4fyVcR4QHxqzpj71GXMXNXMK4an0=";
  };

  postPatch = ''
    substituteInPlace delfin/meson.build --replace-fail \
      "'delfin' / rust_target / meson.project_name()" \
      "'delfin' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
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

  # For https://codeberg.org/avery42/delfin/src/commit/820b466bfd47f71c12e9b2cabb698e8f78942f41/delfin/meson.build#L47-L48
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

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
