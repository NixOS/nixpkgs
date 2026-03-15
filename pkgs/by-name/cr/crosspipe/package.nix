{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  libadwaita,
  libgee,
  pipewire,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crosspipe";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dp0sk";
    repo = "crosspipe";
    tag = finalAttrs.version;
    hash = "sha256-W3OKYdei/4l1uTQIXfzq6aaw2NF7dOBaAFkPTUFOLzA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    pipewire
    libxml2
  ];

  strictDeps = true;

  meta = {
    description = "PipeWire graph GTK4/Libadwaita GUI";
    homepage = "https://github.com/dp0sk/crosspipe";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "crosspipe";
    platforms = lib.platforms.linux;
  };
})
