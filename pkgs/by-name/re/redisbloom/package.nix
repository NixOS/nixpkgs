{
  cmake,
  fetchFromGitHub,
  lib,
  nix-update-script,
  redis,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redisbloom";
  version = "8.10.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RedisBloom";
    repo = "RedisBloom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/CdVi3zBGdSLLXtqGKjtPOB+CK1Wk2yBSrQfCSxURz8=";
    fetchSubmodules = true;
  };

  makeFlags = [
    # Force building shared libray
    "SO_LD_FLAGS=-shared"
    # RedisBloom only supports 64-bit architectures (x64, arm64v8)
    # and requires an extra platform mapping.
    # https://github.com/redis/redis/blob/65401042dc6105eac649dfc3b52eadb3fbb852a2/modules/common.mk#L8-L12
    "ARCH=${
      with stdenv.hostPlatform;
      if isAarch64 then
        "arm64v8"
      else if isx86_64 then
        "x64"
      else
        throw "Unsupported system: ${system}"
    }"
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp bin/*/*.so $out/lib

    runHook postInstall
  '';

  # Try to keep redis modules in sync with the version of redis.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=${redis.version}" ];
  };

  meta = {
    description = "Probabilistic Datatypes Module for Redis";
    homepage = "https://github.com/RedisBloom/RedisBloom";
    changelog = "https://github.com/RedisBloom/RedisBloom/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.intersectLists lib.platforms.linux (lib.platforms.x86_64 ++ lib.platforms.aarch64);
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.redis ];
  };
})
