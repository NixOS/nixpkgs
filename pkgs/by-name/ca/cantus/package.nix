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
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = finalAttrs.version;
    hash = "sha256-JoxGn3AaILLW2vWwPZ06Dr+JF0Cc1P0X7BeJBNGJBuI=";
  };

  cargoHash = "sha256-GIB/QWBjlpkyxeTz15Hf4mr660R++mSf1J+K4JZ+YXY=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
  ];

  runtimeDependencies = [
    libxkbcommon
    vulkan-loader
    wayland
  ];

  buildInputs = [
    stdenv.cc.cc.lib
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
