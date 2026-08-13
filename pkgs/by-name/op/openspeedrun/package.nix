{
  lib,
  fetchFromGitHub,
  rustPlatform,
  wayland,
  libxkbcommon,
  libGL,
  autoPatchelfHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openspeedrun";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "SrWither";
    repo = "OpenSpeedRun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0gVFnQbbtlQG2H0oD28cbbqvGsAxqC5DPsKvHC1CUw8=";
  };

  cargoHash = "sha256-xOz/Ru6NqpI20t+hz/81xaVU6XrsqGx0tI04O6nkRj4=";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  runtimeDependencies = [
    wayland
    libxkbcommon
    libGL
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libgcc_s.so.1"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SrWither/OpenSpeedRun/releases/tag/v${finalAttrs.version}";
    description = "Modern and minimalistic open-source speedrun timer";
    homepage = "https://github.com/SrWither/OpenSpeedRun";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "openspeedrun";
  };
})
