{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jwtinfo";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lmammino";
    repo = "jwtinfo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o2SbPTnYSqsjpTl1Z8uSZZLeHx4lxunwDdig4UuVFKg=";
  };

  cargoHash = "sha256-v5kJ+XznzewkmC3qo1e2xMLc1fS8gYYNd/9+IDFkbvw=";

  meta = {
    description = "Command-line tool to get information about JWTs";
    homepage = "https://github.com/lmammino/jwtinfo";
    changelog = "https://github.com/lmammino/jwtinfo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "jwtinfo";
  };
})
