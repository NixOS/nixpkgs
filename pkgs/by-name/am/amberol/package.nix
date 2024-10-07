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
}:

stdenv.mkDerivation rec {
  pname = "amberol";
  version = "2024.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "amberol";
    rev = version;
    hash = "sha256-WuyvTgh9Qc5WcgEssxkytwQpSACd82l5WKeMD0NFOp8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "amberol-${version}";
    hash = "sha256-C1ENyNUpgwGlZus/zIWD1mUrmWT9L0fH/1T4QaIxGJw=";
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

  buildInputs =
    [
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

  meta = {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "Small and simple sound and music player";
    maintainers = with lib.maintainers; [ linsui ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "amberol";
  };
}
