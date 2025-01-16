{
  lib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chance";
  version = "4.0.1";

  src = fetchFromGitLab {
    owner = "zelikos";
    repo = "rollit";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-25+/TvTba/QF7+QE8+O7u4yc9BNi0pcZeNj11dGkEfg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-Jy/Tc5Rmqh6NIcLzGSIxQg1dLiAkw+xbrdo6qfqrRSg=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dice roller built using GTK4 and libadwaita";
    homepage = "https://gitlab.com/zelikos/rollit";
    changelog = "https://gitlab.com/zelikos/rollit/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "rollit";
    platforms = lib.platforms.linux;
  };
})
