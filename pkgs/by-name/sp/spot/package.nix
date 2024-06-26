{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  gettext,
  desktop-file-utils,
  cargo,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  libadwaita,
  libhandy,
  gtk4,
  openssl,
  alsa-lib,
  libpulseaudio,
  wrapGAppsHook4,
  blueprint-compiler,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "spot";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = version;
    hash = "sha256-F875e/VZyN8mTfe9lgjtILNxMqn+66XoPCdaEUagHyU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-45Rqs2/tSWoyZVjFuygR5SxldjoqpprtOKEnMqJK+p8=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    gtk4 # for gtk-update-icon-cache
    glib # for glib-compile-schemas
    desktop-file-utils
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libhandy
    openssl
    alsa-lib
    libpulseaudio
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ];

  # https://github.com/xou816/spot/issues/313
  mesonBuildType = "release";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Native Spotify client for the GNOME desktop";
    mainProgram = "spot";
    homepage = "https://github.com/xou816/spot";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
