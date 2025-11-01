{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvrs";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "adamperkowski";
    repo = "nvrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ATkebFYuOOvhzSO+gClPbtaz9/Zph4m8/cqkufRYFw=";
  };

  cargoHash = "sha256-h3egaj4RQImxIf0MB8ZM9V92Xlml5BK++s7RJQwAk+E=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  buildFeatures = [ "cli" ];
  cargoBuildFlags = [
    "--bin"
    "nvrs"
  ];

  # Skip tests that rely on network access.
  # We're also not running cli tokio tests because they don't implement skipping functionality.
  checkPhase = ''
    runHook preCheck

    cargo test -- \
      --skip 'api::aur::request_test' \
      --skip 'api::crates_io::request_test' \
      --skip 'api::gitea::request_test' \
      --skip 'api::github::request_test' \
      --skip 'api::gitlab::request_test' \
      --skip 'api::regex::request_test'

    runHook postCheck
  '';

  meta = {
    description = "Fast new version checker for software releases";
    homepage = "https://nvrs.adamperkowski.dev";
    changelog = "https://github.com/adamperkowski/nvrs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamperkowski ];
    mainProgram = "nvrs";
    platforms = lib.platforms.linux;
  };
})
