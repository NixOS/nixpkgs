{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libx11,
  libxtst,
  libxdmcp,
  libxkbfile,
  libxkbcommon,
  libxcb,
  wayland,
  xorgproto,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "venbind";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "tuxinal";
    repo = "venbind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gPyQ6JjqvM2AUuIxCfO0nOLJfyQTX5bbsbKDzlNSqo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-FZTXj8f+ezRhElovKhF3khWc5SqC+22tDHlFe9IHuwo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    cmake
  ];

  buildInputs = [
    libx11
    libxtst
    libxdmcp
    libxkbfile
    libxkbcommon
    libxcb
    wayland
    xorgproto
  ];

  doCheck = false;

  meta = {
    description = "Native module for Vencord";
    homepage = "https://github.com/tuxinal/venbind";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
