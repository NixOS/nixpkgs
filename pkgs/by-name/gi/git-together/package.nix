{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  darwin,
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
  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.Security;

  OPENSSL_NO_VENDOR = true;

  useFetchCargoVendor = true;
  cargoHash = "sha256-5LKKjHzIlXw0bUmF7GDCVW0cptCxohq6CNPIrMZKorM=";

  meta = with lib; {
    changelog = "https://github.com/kejadlen/git-together/releases/tag/v${version}";
    description = "Better commit attribution while pairing without messing with your git workflow";
    homepage = "https://github.com/kejadlen/git-together";
    license = licenses.mit;
    maintainers = with maintainers; [ sentientmonkey ];
    mainProgram = "git-together";
  };
}
