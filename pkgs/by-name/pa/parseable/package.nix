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
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${version}";
    hash = "sha256-+KTSpkrMlIu24YvHvLOLHZiqRZua3D7/kprFqtRuNOQ=";
  };

  LOCAL_ASSETS_PATH = fetchzip {
    url = "https://parseable-prism-build.s3.us-east-2.amazonaws.com/v${version}/build.zip";
    hash = "sha256-tSH9gyB9T2ywut+joLIp55Us2ALKvgsyiG/gBQgYLfI=";
  };

  cargoHash = "sha256-3hMGiQmXxar4n4cGPrj4UUznNi8V5YokH+29UGmz34Y=";

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
