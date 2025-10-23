{
  lib,
  stdenv,
  alsa-lib,
  appstream-glib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  libhandy,
  libpulseaudio,
  meson,
  ninja,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "spot";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "xou816";
    repo = "spot";
    rev = "refs/tags/${version}";
    hash = "sha256-7zWK0wkh53ojnoznv4T/X//JeyKJVKOrfYF0IkvciIY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-731aD+yJkyrNMmYtgKYzXIAyLegDBzTT2XqZs5usXiI=";
  };

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "cargo_output = 'src' / rust_target / meson.project_name()" \
      "cargo_output = 'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    gettext
    glib # for glib-compile-schemas
    gtk4 # for gtk-update-icon-cache
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libhandy
    libpulseaudio
    openssl
  ];

  # https://github.com/xou816/spot/issues/313
  mesonBuildType = "release";

  # For https://github.com/xou816/spot/blob/21ee601f655caa4ca9cae1033a27459fe6289318/src/meson.build#L122
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Native Spotify client for the GNOME desktop";
    homepage = "https://github.com/xou816/spot";
    changelog = "https://github.com/xou816/spot/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "spot";
    platforms = lib.platforms.linux;
  };
}
