{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cjson";
  version = "1.7.19";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WjgzokT9aHJ7dB40BtmhS7ur1slTuXmemgDimZHLVQM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin) (
    lib.cmakeBool "ENABLE_CUSTOM_COMPILER_FLAGS" false
  );

  postPatch =
    # cJSON actually uses C99 standard, not C89
    # https://github.com/DaveGamble/cJSON/issues/275
    ''
      substituteInPlace CMakeLists.txt --replace -std=c89 -std=c99
    ''
    # Fix the build with CMake 4.
    #
    # See:
    # * <https://github.com/DaveGamble/cJSON/issues/946>
    # * <https://github.com/DaveGamble/cJSON/pull/935>
    # * <https://github.com/DaveGamble/cJSON/pull/949>
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'cmake_minimum_required(VERSION 3.0)' \
          'cmake_minimum_required(VERSION 3.10)'
    '';

  meta = {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.unix;
  };
})
