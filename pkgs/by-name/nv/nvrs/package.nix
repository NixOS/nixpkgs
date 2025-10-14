{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nvrs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "adamperkowski";
    repo = "nvrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JnVDZdf+/ktBNrRC7Yn9VmxZZcYSsZRORK4rN+60Pc0=";
  };

  cargoHash = "sha256-R+mVnUxiUagU5TBemZqwRQ6/phdFvwVQT9vp+uYKOSI=";

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
