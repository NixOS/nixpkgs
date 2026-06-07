{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  cyrus_sasl,
  libevent,
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

  nativeBuildInputs = [
    bison
    cmake
    flex
  ];

  cmakeFlags = [
    "-DENABLE_SASL=ON"
  ];

  buildInputs = [ libevent ];
  propagatedBuildInputs = [ cyrus_sasl ];

  meta = {
    homepage = "https://github.com/awesomized/libmemcached";
    changelog = "https://github.com/awesomized/libmemcached/blob/${finalAttrs.src.tag}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "Open source C/C++ client library and tools for the memcached server";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
