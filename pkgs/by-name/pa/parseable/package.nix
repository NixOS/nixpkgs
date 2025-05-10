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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
    hash = "sha256-oMDFi5cBcghxzwmmR/Gg50PcYCb6HaxDqWA8vVyw30Y=";
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://github.com/parseablehq/console/releases/download/v0.9.15/build.zip";
    hash = "sha256-T37pI7adfKPDkCETcGcZVzcYVcxROSZLDrFhV4XO4tc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kVLUSu+9jW3M0YosmpZWDIKCj7GilZZibMMtufHPdfM=";

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
