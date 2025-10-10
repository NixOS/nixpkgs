{
  lib,
  rdkafka,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
  fetchzip,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "parseable";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
    hash = "sha256-F6sMa8uHLI4RFaThoQn4MUqeIimri/MwJJwPMvZ2C2A=";
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://parseable-prism-build.s3.us-east-2.amazonaws.com/v${version}/build.zip";
    hash = "sha256-7uJvWAGDexzWhnm1ofPHzoRD8Q70fQ+eyUPpQHcWv4o=";
  };

  cargoHash = "sha256-u0q+GF1k+RJWSK5xadOprQ9DvTORHXNnnj0qTg1BEjM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ rdkafka ];

  buildFeatures = [ "rdkafka/dynamic-linking" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Disk less, cloud native database for logs, observability, security, and compliance";
    homepage = "https://www.parseable.com";
    changelog = "https://github.com/parseablehq/parseable/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
    mainProgram = "parseable";
  };
}
