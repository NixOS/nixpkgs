{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  glib,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  libadwaita,
  libxml2,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "design";
    repo = "emblem";
    tag = version;
    hash = "sha256-hKsME/edn8E+tKF3TbhqQF7GsRdbvfXprV4fFgHdx6w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-M0z+twxu16FON/OgbG3SCfVYCHAkkfSzf5QTt983MhA=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    libadwaita
    libxml2
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=incompatible-function-pointer-types"
    ]
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Generate project icons and avatars from a symbolic icon";
    mainProgram = "emblem";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    teams = [ lib.teams.gnome-circle ];
  };
}
