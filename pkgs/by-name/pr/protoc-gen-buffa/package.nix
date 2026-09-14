{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "protoc-gen-buffa";
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
    "protoc-gen-buffa"
  ];

  cargoTestFlags = [
    "-p"
    "protoc-gen-buffa"
  ];

  meta = {
    description = "Protoc plugin for generating Rust code with buffa";
    homepage = "https://github.com/anthropics/buffa";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "protoc-gen-buffa";
  };
})
