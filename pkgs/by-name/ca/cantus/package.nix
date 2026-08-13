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
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = finalAttrs.version;
    hash = "sha256-TRqWhoRlinNzLdxODs4bR5IgJR6ELKs4SOOpvtoFNFA=";
  };

  cargoHash = "sha256-YUXEgeZn0UXh34RnCaqLhhK0QSPz3Y8XJuR2oMa4rIU=";

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
