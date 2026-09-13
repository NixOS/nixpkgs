{
  fetchFromGitHub,
  lib,
  nix-update-script,
  redis,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redisjson";
  version = "8.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RedisJSON";
    repo = "RedisJSON";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MHqznHladN0UhXdqptK5+B6dRxOy/znG7FtEByDzyyY=";
  };

  cargoHash = "sha256-yRp1DFAGyy3pJS0jRlvHGy1eLYz6IE2pi+f58CqRgIY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  # Try to keep redis modules in sync with the version of redis.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=${redis.version}" ];
  };

  meta = {
    description = "JSON data type for Redis";
    license = lib.licenses.agpl3Only;
    mainProgram = "jsonpath";
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
