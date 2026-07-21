{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bison,
  cmake,
  flex,
  cyrus_sasl,
  libevent,
  ctestCheckHook,
  memcached,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmemcached";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "awesomized";
    repo = "libmemcached";
    tag = finalAttrs.version;
    hash = "sha256-jEw6L2/139oo4sGprl9Xp0DTarxAK1bEF2ak2kHWSAs=";
  };

  patches = [
    (fetchpatch {
      name = "libcxx-compat.patch";
      url = "https://github.com/awesomized/libmemcached/commit/547460c12287a34a5993045157a0e13e14203f92.patch";
      includes = [ "test/lib/random.cpp" ];
      hash = "sha256-aH51O4UM3M4yzTtC8bTy+6NKrtPfgqysrvspMZ/gWDc=";
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    flex
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    "-DENABLE_SASL=ON"
  ];

  buildInputs = [ libevent ];
  propagatedBuildInputs = [ cyrus_sasl ];

  doCheck = true;

  nativeCheckInputs = [
    ctestCheckHook
    memcached
  ];

  disabledTests = [
    "bin/memcapable"
    "memcached_regression_lp583031"
  ];

  meta = {
    homepage = "https://github.com/awesomized/libmemcached";
    changelog = "https://github.com/awesomized/libmemcached/blob/${finalAttrs.src.tag}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "Open source C/C++ client library and tools for the memcached server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
