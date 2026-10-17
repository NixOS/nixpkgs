{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  openssl,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtz";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "twitchax";
    repo = "rtz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g72M7Iohq8S8m8kx7P+GER+QUOi7u2aFDi1H7JT4mZ8=";
  };

  cargoHash = "sha256-rBXPS2y3XZFoxs9fvBKoJgFsSKRNQ8NJu+hvuc8axug=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    openssl
    zstd
  ];

  buildFeatures = [ "web" ];

  meta = {
    description = "Tool to easily work with timezone lookups via a binary, a library, or a server";
    homepage = "https://github.com/twitchax/rtz";
    changelog = "https://github.com/twitchax/rtz/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rtz";
  };
})
