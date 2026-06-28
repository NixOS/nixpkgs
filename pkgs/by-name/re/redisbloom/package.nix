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
  version = "8.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RedisBloom";
    repo = "RedisBloom";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vagAHAJBbgeAfGadCeHe4RUJABMFzCB1uor/YuBiE6k=";
  };

  makeFlags = [
    # Force building shared libray
    "SO_LD_FLAGS=-shared"
    # Some modules require an extra platform mapping.
    # https://github.com/redis/redis/blob/65401042dc6105eac649dfc3b52eadb3fbb852a2/modules/common.mk#L8-L12
    "ARCH=${
      with stdenv.hostPlatform;
      if isAarch64 then
        "arm64v8"
      else if (isx86 || isi686) then
        "x64"
      else
        throw "Unsupported sytem: ${system}"
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
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
