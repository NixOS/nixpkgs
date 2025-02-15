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

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "5.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
    rev = version;
    hash = "sha256-Xf/b/9o6zHF1hjHSyAXb90ySoBj+DMMe31e6RfF8C4Y=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jtMTW9tIf0UGbE9bJU31maub+o0agf0pDRO4s9QReyc=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "Pomodoro timer for the GNOME desktop";
    maintainers = with maintainers; [ linsui ] ++ lib.teams.gnome-circle.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "solanum";
  };
}
