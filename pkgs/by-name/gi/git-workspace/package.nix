{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-workspace";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "git-workspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+cTN1TwM/mo1bH3IOeS3f451DfhuXLkNTcaKgzAqmFI=";
  };

  cargoHash = "sha256-NEL9gsvsIBqz2/4GmTRgx7n0s986zVHOeTWQaQyXT4U=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlags = [
    # integration tests, need docker
    # https://rust.testcontainers.org/system_requirements/docker/
    "--skip=test_archive_command"
    "--skip=test_fetch_and_run_commands"
    "--skip=test_update_command"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misuzu ];
    mainProgram = "git-workspace";
  };
})
