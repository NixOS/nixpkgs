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
  version = "v0.1.0-alpha.26";

  src = fetchFromGitHub {
    owner = "kejadlen";
    repo = "git-together";
    rev = version;
    hash = "sha256-2HgOaqlX0mmmvRlALHm90NAdIhby/jWUJO63bQFqc+4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin darwin.Security;

  OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-mIkhXVuSgcsQf4be7NT0R8rkN9tdgim41gqjbq3ndPA=";

  meta = with lib; {
    changelog = "https://github.com/kejadlen/git-together/releases/tag/${src.rev}";
    description = "Better commit attribution while pairing without messing with your git workflow";
    homepage = "https://github.com/kejadlen/git-together";
    license = licenses.mit;
    maintainers = with maintainers; [ sentientmonkey ];
    mainProgram = "git-together";
  };
}
