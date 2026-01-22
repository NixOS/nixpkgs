{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "git-workspace";
    tag = "v${version}";
    hash = "sha256-SeE8O48lzqJSg8rfmIgsUcGPbquo2OvK3OUUBG21ksc=";
  };

  cargoHash = "sha256-CaHZivayZNuCi8vID8Qr5j/Ed+GGdNu+7NznvsCb3j0=";

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
}
