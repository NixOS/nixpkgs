{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  validatePkgConfig,
  secureMemory ? false,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsoncpp";
  version = "1.9.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = finalAttrs.version;
    sha256 = "sha256-3msc3B8NyF8PUlNaAHdUDfCpcUmz8JVW2X58USJ5HRw=";
  };

  /*
    During darwin bootstrap, we have a cp that doesn't understand the
    --reflink=auto flag, which is used in the default unpackPhase for dirs
  */
  unpackPhase = ''
    cp -a ${finalAttrs.src} ${finalAttrs.src.name}
    chmod -R +w ${finalAttrs.src.name}
    export sourceRoot=${finalAttrs.src.name}
  '';

  postPatch = lib.optionalString secureMemory ''
    sed -i 's/#define JSONCPP_USING_SECURE_MEMORY 0/#define JSONCPP_USING_SECURE_MEMORY 1/' include/json/version.h
  '';

  nativeBuildInputs = [
    cmake
    python3
    validatePkgConfig
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_OBJECT_LIBS=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
    "-DBUILD_STATIC_LIBS=${if enableStatic then "ON" else "OFF"}"
  ]
  # the test's won't compile if secureMemory is used because there is no
  # comparison operators and conversion functions between
  # std::basic_string<..., Json::SecureAllocator<char>> vs.
  # std::basic_string<..., [default allocator]>
  ++ lib.optional (
    (stdenv.buildPlatform != stdenv.hostPlatform) || secureMemory
  ) "-DJSONCPP_WITH_TESTS=OFF";

  meta = {
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "C++ library for interacting with JSON";
    maintainers = with lib.maintainers; [ ttuegel ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
