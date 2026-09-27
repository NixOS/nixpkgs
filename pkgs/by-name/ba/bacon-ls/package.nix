{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  testers,
  perl,
  bacon-ls,
}:

rustPlatform.buildRustPackage rec {
  pname = "bacon-ls";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "crisidev";
    repo = pname;
    rev = version;
    sha256 = "sha256-9r+3LzIENjQ4Y3TMXbQjifG5ObMwCqxMfOiLpRwu8Nc=";
  };

  nativeBuildInputs = [ perl ];

  cargoLock.lockFile = ./Cargo.lock;

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
    tests.version = testers.testVersion {
      package = bacon-ls;
      command = "bacon-ls --version";
    };
  };

  meta = {
    description = "A Language Server for Rust using Bacon diagnostics";
    homepage = "https://github.com/crisidev/bacon-ls";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.giggio ];
    mainProgram = "bacon-ls";
    platforms = lib.platforms.unix;
  };
}
