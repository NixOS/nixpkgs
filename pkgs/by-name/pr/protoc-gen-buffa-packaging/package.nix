{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "protoc-gen-buffa-packaging";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "buffa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTKa4Wdc9SwjNZFZ2iKVKfE+hGpXZbVY8+ndJ908tMc=";
  };

  cargoHash = "sha256-0MuE998GRVHdd0quotESyTVzjRhB8dPC0TDw+mpARK0=";

  cargoBuildFlags = [
    "-p"
    "protoc-gen-buffa-packaging"
  ];

  cargoTestFlags = [
    "-p"
    "protoc-gen-buffa-packaging"
  ];

  meta = {
    description = "Protoc plugin that emits a mod.rs module tree for buffa per-file output";
    homepage = "https://github.com/anthropics/buffa";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "protoc-gen-buffa-packaging";
  };
})
