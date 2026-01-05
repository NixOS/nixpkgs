{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wipe";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mihai-dinculescu";
    repo = "cargo-wipe";
    rev = "v${version}";
    sha256 = "sha256-r+JMM6KUqcqpLi1Js/2RI8FSoaA5f7yXJ1EuCJB1fyE=";
  };

  cargoHash = "sha256-fg1QjHSnK3lxim/t7AO/w1eIKfpJmYqGSGTpakUKBfk=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = ''Cargo subcommand "wipe": recursively finds and optionally wipes all "target" or "node_modules" folders'';
    mainProgram = "cargo-wipe";
    homepage = "https://github.com/mihai-dinculescu/cargo-wipe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
