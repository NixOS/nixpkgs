{
  autoconf,
  automake,
  cmake,
  fetchFromGitHub,
  glibtool,
  jq,
  lib,
  libtool,
  nix-update-script,
  openssl,
  redis,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redistimeseries";
  version = "8.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RedisTimeSeries";
    repo = "RedisTimeSeries";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-KcxRuoXvQ48uaNx5ycUzfW2wuS8KVyICQNaxf6dT8Lc=";
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

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    jq
    libtool
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ glibtool ];

  buildInputs = [
    openssl
  ];

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
    # Currently only supports 64bit platforms.
    # https://github.com/RedisTimeSeries/RedisTimeSeries/blob/b0ecf8a8cbb903cd227ce61db46735f01486a3b9/Makefile#L35-L37
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
    description = "Time Series data structure for Redis";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
