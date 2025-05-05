{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  python3,
  git,
  glib,
  gtk4,
  gst_all_1,
  libadwaita,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solanum";
  version = "6.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
    tag = finalAttrs.version;
    hash = "sha256-Wh9/88Vc4mtjL0U1Vrw+GEEBPjEv+5NrWd/Kw1glp+w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-krjbeutochFk5md+THlYBW4iEwfFDbK89DYHZyd3IKo=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    python3
    git
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "Pomodoro timer for the GNOME desktop";
    maintainers = with lib.maintainers; [ linsui ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "solanum";
  };
})
