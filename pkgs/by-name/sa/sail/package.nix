{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  pkg-config,
  python3,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sail";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "lakehq";
    repo = "sail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z2XOce95VTlZSTaxRMkTYoXVRiT8cgAk/lK/zLu2Zpo=";
  };

  cargoHash = "sha256-aZBABAFA3vVxTImRqZAZ/RwUQIQU+VvKzbRfIM0k8FU=";

  cargoBuildFlags = [
    "-p"
    "sail-cli"
  ];
  cargoTestFlags = [
    "-p"
    "sail-cli"
  ];

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    python3
  ];

  env = {
    PYO3_PYTHON = lib.getExe python3;
    PROTOC = lib.getExe protobuf;
  };

  # Tests require a running server
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spark-compatible compute engine built on Apache Arrow and DataFusion";
    homepage = "https://github.com/lakehq/sail";
    changelog = "https://github.com/lakehq/sail/blob/v${finalAttrs.version}/docs/reference/changelog/index.md";
    license = lib.licenses.asl20;
    mainProgram = "sail";
    maintainers = [ lib.maintainers.davidlghellin ];
  };
})
