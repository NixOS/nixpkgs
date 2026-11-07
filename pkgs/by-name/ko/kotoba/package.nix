{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  libadwaita,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kotoba";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "haydn";
    repo = "kotoba";
    tag = finalAttrs.version;
    hash = "sha256-DVXwstm+6XVQybdro3dbn5R6JnFHxfS+iYqm/P5S5eo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3juPjaGGQxJQvNjRm7GGZbV8AL9YUKUHwpPHbJyIJuM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/kotoba --help > /dev/null
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/haydn/kotoba";
    description = "Japanese–English dictionary";
    maintainers = with lib.maintainers; [ lethargii ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kotoba";
  };
})
