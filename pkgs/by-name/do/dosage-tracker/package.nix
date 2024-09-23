{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
  gjs,
  libportal-gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dosage-tracker";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "diegopvlk";
    repo = "Dosage";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-c6abXGmf3TDtqP7+SI1PHpqEqbPBkQyl/xNrMjHqUS4=";
  };

  patches = [ ./set_resource_path.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    gjs
    libportal-gtk4
  ];

  meta = {
    description = "Keep track of your treatments";
    homepage = "https://github.com/diegopvlk/Dosage";
    license = lib.licenses.gpl3Only;
    mainProgram = "io.github.diegopvlk.Dosage";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
