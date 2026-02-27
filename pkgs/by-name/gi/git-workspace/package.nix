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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "git-workspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1/3P7SenUhPrN19cVVrKxFsQt75FR0BG1P3ef3galPg=";
  };

  cargoHash = "sha256-JoPs8Py8yaJ7A+OHKxDx3OwXbiJxKR2ZtkQAzXlXgJM=";

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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ misuzu ];
    mainProgram = "git-workspace";
  };
})
