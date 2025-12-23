{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-together";
  version = "0.1.0-alpha.26";

  src = fetchFromGitHub {
    owner = "kejadlen";
    repo = "git-together";
    tag = "v${version}";
    hash = "sha256-2HgOaqlX0mmmvRlALHm90NAdIhby/jWUJO63bQFqc+4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-5LKKjHzIlXw0bUmF7GDCVW0cptCxohq6CNPIrMZKorM=";

  meta = {
    changelog = "https://github.com/kejadlen/git-together/releases/tag/v${version}";
    description = "Better commit attribution while pairing without messing with your git workflow";
    homepage = "https://github.com/kejadlen/git-together";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sentientmonkey ];
    mainProgram = "git-together";
  };
}
