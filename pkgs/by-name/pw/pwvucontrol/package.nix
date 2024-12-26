{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  pipewire,
  wireplumber,
}:

let
  wireplumber_0_4 = wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pwvucontrol";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-v8xANTbaIPIAPoukP8rcVzM6NHNpS2Ej/nfdmg3Vgvg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "wireplumber-0.1.0" = "sha256-ocagwmjyhfx6n/9xKxF2vhylqy2HunKQRx3eMo6m/l4=";
    };
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    pipewire
    wireplumber_0_4
  ];

  meta = {
    description = "Pipewire Volume Control";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      figsoda
      Guanran928
      johnrtitor
    ];
    mainProgram = "pwvucontrol";
    platforms = lib.platforms.linux;
  };
})
