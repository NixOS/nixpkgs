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
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
    hash = "sha256-irZYHzGRoyPqPG4K5786FpBGDUlP07Q1DSe2scqY/ic=";
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://parseable-prism-build.s3.us-east-2.amazonaws.com/v${version}/build.zip";
    hash = "sha256-3lGpRNYlDyWnDH4iO3+ZAzwqD52fzRc01k9318aS7Xg=";
  };

  cargoHash = "sha256-+XlFVB2XxnXyYqgUVh5HhkvvbOPtEDhjsJyKcAGe/Ew=";

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
