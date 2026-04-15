{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  stdenv,
  wayland,
  vulkan-loader,
  libxkbcommon,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cantus";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = finalAttrs.version;
    hash = "sha256-C/djQKG25azM/Vfw6UurPhgIyHGhWcMwM8FXQt+alko=";
  };

  cargoHash = "sha256-qg7YeIJVDzrAmUNUjfIB7eoZYUTMNu69L7dlZ6D9nLU=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  runtimeDependencies = [
    libxkbcommon
    vulkan-loader
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    wayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful interactive music widget for Wayland";
    homepage = "https://github.com/CodedNil/cantus";
    license = lib.licenses.mit;
    mainProgram = "cantus";
    maintainers = with lib.maintainers; [ CodedNil ];
    platforms = lib.platforms.linux;
  };
})
