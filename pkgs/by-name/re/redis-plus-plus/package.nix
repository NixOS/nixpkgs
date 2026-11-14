{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  hiredis,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

# You must build at one type of library
assert enableShared || enableStatic;

stdenv.mkDerivation (finalAttrs: {
  pname = "redis-plus-plus";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "sewenew";
    repo = "redis-plus-plus";
    rev = finalAttrs.version;
    hash = "sha256-0q+pQ2tS04RYKsikTG5QMuTPW3f6+fFIPuJZVf/aIw0=";
  };

  patches = [
    ./0001-Fix-pkg-config-paths.patch

    # https://github.com/sewenew/redis-plus-plus/issues/678
    (fetchpatch2 {
      name = "walk-around-gcc-16-bug.patch";
      url = "https://github.com/sewenew/redis-plus-plus/commit/4b4cd0dc2931e96842ef05e165673b8679e32f48.patch?full_index=1";
      hash = "sha256-neZj/J9nRg3Ft/+wQcRzvTjwm41odNnEfHnrs8/KiL4=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ hiredis ];

  cmakeFlags = [
    "-DREDIS_PLUS_PLUS_BUILD_TEST=OFF"
  ]
  ++ lib.optionals (!enableShared) [
    "-DREDIS_PLUS_PLUS_BUILD_SHARED=OFF"
  ]
  ++ lib.optionals (!enableStatic) [
    "-DREDIS_PLUS_PLUS_BUILD_STATIC=OFF"
  ];

  meta = {
    homepage = "https://github.com/sewenew/redis-plus-plus";
    description = "Redis client written in C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wheelsandmetal ];
  };
})
