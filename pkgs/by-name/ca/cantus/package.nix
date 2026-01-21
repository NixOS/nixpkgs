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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "CodedNil";
    repo = "cantus";
    tag = version;
    hash = "sha256-/gwZqr66rpD7w9EuN03vKRWVH/DYDLUvijEkmrN2E+c=";
  };

  cargoHash = "sha256-vC/07gvVMH/UATFl7NvJTRLzIOSjrelzINmQ6zUBSos=";

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
