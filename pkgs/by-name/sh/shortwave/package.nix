{
  stdenv,
  lib,
  fetchFromGitLab,
  cargo,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  gitMinimal,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  wrapGAppsHook4,
  libshumate,
  libseccomp,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "shortwave";
  version = "4.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "sha256-W1eOMyiooDesI13lOze/JcxzhSSxYOW6FOY85NkVyps=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-O5K5aNcWwUYkaJbGzTzS3FdNbEsQsdliyi0YShw+6PU=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gitMinimal
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs =
    [
      dbus
      gdk-pixbuf
      glib
      gtk4
      libadwaita
      openssl
      sqlite
      libshumate
      libseccomp
      lcms2
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]);

  meta = {
    homepage = "https://gitlab.gnome.org/World/Shortwave";
    description = "Find and listen to internet radio stations";
    mainProgram = "shortwave";
    maintainers = with lib.maintainers; [ lasandell ] ++ lib.teams.gnome-circle.members;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
