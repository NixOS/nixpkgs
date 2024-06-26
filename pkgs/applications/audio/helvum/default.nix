{
  lib,
  cargo,
  clang,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pipewire,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "helvum";
  version = "0.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pipewire";
    repo = pname;
    rev = version;
    hash = "sha256-9vlzLPpyZ9qtCEbCDvYhWDcV+8T63ukdos1l2U6fD+E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Xebm3XlsO6kBoMnxJsOk/3SO7avVoaGqi2CVWBRzr88=";
  };

  nativeBuildInputs = [
    clang
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustPlatform.bindgenHook
    wrapGAppsHook4
  ];

  buildInputs = [
    desktop-file-utils
    glib
    gtk4
    libadwaita
    pipewire
  ];

  meta = with lib; {
    description = "GTK patchbay for pipewire";
    homepage = "https://gitlab.freedesktop.org/pipewire/helvum";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fufexan ];
    platforms = platforms.linux;
    mainProgram = "helvum";
  };
}
