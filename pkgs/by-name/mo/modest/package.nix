{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modest";
  version = "0-unstable-2021-08-03";

  src = fetchFromGitHub {
    owner = "lexborisov";
    repo = "modest";
    rev = "2540a03259fc62fe15f47e85c20b2eedd5af66de";
    hash = "sha256-o3asVErtc9CYRb3ZZFE5DYyT/Pjr7TZ79BLPnh6CCT0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-void-pointer-to-enum-cast"
      "-Wno-unused-but-set-variable"
    ]
  );

  meta = {
    description = "Fast HTML renderer implemented as a pure C99 library with no outside dependencies";
    homepage = "https://github.com/lexborisov/Modest";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.drupol ];
    platforms = lib.platforms.all;
  };
})
