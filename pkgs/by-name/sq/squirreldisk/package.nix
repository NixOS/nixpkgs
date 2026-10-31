{
  lib,
  stdenv,

  alsa-lib,
  autoPatchelfHook,
  fetchFromGitHub,
  libgcc,
  libGL,
  libx11,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "squirreldisk";
  version = "v2.6.1";

  src = fetchFromGitHub {
    owner = "adileo";
    repo = "squirreldisk";
    tag = finalAttrs.version;
    hash = "sha256-SyPxZPZso6gnu0xesD70FtFtDP9hrJk8DdtDzLzg6ys=";
  };

  cargoHash = "sha256-A4xRYpxjl2dF3PGag21hAKOZtJQjI9cLsCLnhSvTGUE=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib.dev
    libgcc
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    libxkbcommon
    libx11
    libGL
  ];

  meta = {
    description = "Free, open-source disk usage analyzer for macOS, Windows and Linux";
    homepage = "https://www.squirreldisk.com/";
    mainProgram = "squirreldisk";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ peret ];
  };
})
