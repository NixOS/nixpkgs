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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = finalAttrs.version;
    hash = "sha256-dAMphU+voDUwFzlPuV6nCUg0RaVVyRJLoM6IwjUtvA4=";
  };

  cargoHash = "sha256-0RVjHKg2msoxY+0WZHOPOAXK2nNne7CA9owmNUf8x6I=";

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
