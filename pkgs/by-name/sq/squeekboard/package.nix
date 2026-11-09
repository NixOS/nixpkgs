{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  pkg-config,
  gnome-desktop,
  glib,
  gtk3,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libbsd,
  libxml2,
  libxkbcommon,
  rustPlatform,
  rustc,
  feedbackd,
  wrapGAppsHook3,
  nixosTests,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.43.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "squeekboard";
    rev = "v${version}";
    hash = "sha256-UsUr4UnYNo2ybEdNyOD/IiafEZ1YJFwRQ3CVy76X2H0=";
  };

  patches = [
    # Match libc's close() signature, rejected by rustc's invalid_runtime_symbol_definitions lint since 1.98
    # https://gitlab.gnome.org/World/Phosh/squeekboard/-/merge_requests/714
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Phosh/squeekboard/-/commit/82c754a92807ffa851defd59dea99bee652a2b2b.patch";
      hash = "sha256-JmAWpNRkLL08LiDTHHV7le9mrzzBqipDaEhgq772m+M=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-3K1heokPYxYbiAGha9TrrjQXguzGv/djIB4eWa8dVjg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    wayland-scanner
    wrapGAppsHook3
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk3
    gnome-desktop
    wayland
    wayland-protocols
    libbsd
    libxml2
    libxkbcommon
    feedbackd
  ];

  passthru.tests.phosh = nixosTests.phosh;

  meta = {
    description = "Virtual keyboard supporting Wayland";
    homepage = "https://gitlab.gnome.org/World/Phosh/squeekboard";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artturin ];
    mainProgram = "squeekboard";
    platforms = lib.platforms.linux;
  };
}
