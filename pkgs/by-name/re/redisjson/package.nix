{
  fetchFromGitHub,
  lib,
  nix-update-script,
  redis,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redisjson";
  version = "8.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RedisJSON";
    repo = "RedisJSON";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eHLQvzFrCOrEHJwFESUX+0+nIBiB7NEoapos1A/zeOk=";
  };

  cargoHash = "sha256-EXFR0hM5IX2shMrZRmD0an+xg8vAhlKDoQVDxrH+h0A=";

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
