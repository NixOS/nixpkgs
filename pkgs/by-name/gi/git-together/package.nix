{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv, # for meta.broken
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-together";
  version = "0.1.0-alpha.26";

  src = fetchFromGitHub {
    owner = "kejadlen";
    repo = "git-together";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2HgOaqlX0mmmvRlALHm90NAdIhby/jWUJO63bQFqc+4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  cargoHash = "sha256-5LKKjHzIlXw0bUmF7GDCVW0cptCxohq6CNPIrMZKorM=";

  meta = {
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/kejadlen/git-together/releases/tag/v${finalAttrs.version}";
    description = "Better commit attribution while pairing without messing with your git workflow";
    homepage = "https://github.com/kejadlen/git-together";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sentientmonkey ];
    mainProgram = "git-together";
  };
})
