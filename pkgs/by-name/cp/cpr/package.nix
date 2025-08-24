{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  curl,
  zlib,
  gtest,
  cppcheck,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpr";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "libcpr";
    repo = "cpr";
    tag = finalAttrs.version;
    hash = "sha256-OkOyh2ibt/jX/Dc+TB1uSlWtzEhdSQwHVN96oCOh2yM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    gtest
    cppcheck
  ];

  buildInputs = [
    openssl
    zlib
    curl
  ];

  cmakeFlags = [
    # NOTE: Does not build with CPPCHECK
    # (lib.cmakeBool "CPR_ENABLE_CPPCHECK" true)
    (lib.cmakeBool "CPR_BUILD_TEST" true)
    (lib.cmakeBool "CURL_ZLIB" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "CPR_USE_SYSTEM_CURL" true)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
  ];

  # Install headers
  postInstall = ''
    mkdir -p $out/include
    cp -r $src/include/* $out/include/
  '';

  meta = {
    description = "C++ Requests: Curl for People, a spiritual port of Python Requests";
    homepage = "https://github.com/libcpr/cpr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
