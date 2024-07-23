{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = finalAttrs.src.repo;
  version = "2022-04-12";

  src = fetchFromGitHub {
    owner = "h5p9sl";
    repo = "hmac_sha256";
    rev = "9445307885b86fb997b10f49ada5bee47496950a";
    hash = "sha256-6Zl5qfd22x5P1+ZlqIyH6w1dcnzOhxMJaARMa7yxShU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = ''
      Minimal HMAC-SHA256 implementation in C / C++
    '';
    # TODO maintainer, nix@greenkeypartners.io?
  };
})
