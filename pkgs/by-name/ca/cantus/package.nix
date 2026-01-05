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
rustPlatform.buildRustPackage rec {
  pname = "cantus";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = version;
    hash = "sha256-U8a0LcNlaiLdba4z2LUBQkwrOrE/7S9OIQ4JJw1m4Ck=";
  };

  cargoHash = "sha256-mpjcX5xuhsqr3Jxva8Oy1tQvM+29N3LHvym76Bs0uhk=";

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
}
