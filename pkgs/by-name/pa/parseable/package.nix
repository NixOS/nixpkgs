{
  lib,
  stdenv,
  rdkafka,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
  fetchzip,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parseable";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "parseablehq";
    repo = "parseable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pGmwB8dVz/+930z+7DdwntpgPH13yDy23JbuW8ANX1M=";
  };

  env.LOCAL_ASSETS_PATH = fetchzip {
    url = "https://parseable-prism-build.s3.us-east-2.amazonaws.com/v${finalAttrs.version}/build.zip";
    hash = "sha256-gWzfucetsJJSSjI9nGm7I8xLo0t1VKb4AertiEGuLWA=";
  };

  cargoHash = "sha256-UXp174CgRs1MNykWOCBExKugrv3Y2zhhcK871XZPKQM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ rdkafka ];

  buildFeatures = [ "rdkafka/dynamic-linking" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Disables tests that rely on hostnames.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=generate_correct_path_with_current_time_and"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Disk less, cloud native database for logs, observability, security, and compliance";
    homepage = "https://www.parseable.com";
    changelog = "https://github.com/parseablehq/parseable/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 ];
    mainProgram = "parseable";
  };
})
