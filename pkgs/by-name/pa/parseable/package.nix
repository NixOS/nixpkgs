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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
    hash = "sha256-y4oJnrSFn01DdInUrLx8a84PJTPzssP6TSelYMS3qxU=";
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://github.com/parseablehq/console/releases/download/v0.9.15/build.zip";
    hash = "sha256-T37pI7adfKPDkCETcGcZVzcYVcxROSZLDrFhV4XO4tc=";
  };

  cargoHash = "sha256-foxiE306bsxCPpgnLGrxdSa2Y2HLMaffB4WhMLKU2hQ=";

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
