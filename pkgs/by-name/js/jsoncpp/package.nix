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
  version = "1.9.8";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    tag = finalAttrs.version;
    hash = "sha256-5cH9G4/TVCM5HX6QSk3P4m5+cwuK4x8hP9FohBcmjik=";
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

  nativeBuildInputs = [
    cmake
    python3
    validatePkgConfig
  ];

  cmakeFlags = [
    "-DJSONCPP_USE_SECURE_MEMORY=${if secureMemory then "ON" else "OFF"}"
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
    changelog = "https://github.com/open-source-parsers/jsoncpp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "C++ library for interacting with JSON";
    maintainers = with lib.maintainers; [ hythera ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
