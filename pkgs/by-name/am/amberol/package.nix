{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  appstream-glib,
  meson,
  ninja,
  pkg-config,
  reuse,
  rustc,
  m4,
  wrapGAppsHook4,
  glib,
  gtk4,
  gst_all_1,
  libadwaita,
  dbus,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "amberol";
  version = "2025.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "amberol";
    tag = version;
    hash = "sha256-vF6O7+cQFoYpO4MHHHuacwjP7AUqFQCVUivCSZO7v3o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "amberol-${version}";
    hash = "sha256-j/xkdLcmu02e+b8skx5U3uG2R2rIxwSJsYzyJ5tn5uU=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    appstream-glib
    cargo
    desktop-file-utils
    m4
    meson
    ninja
    pkg-config
    reuse
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "Small and simple sound and music player";
    maintainers = with lib.maintainers; [ linsui ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "amberol";
  };
}
