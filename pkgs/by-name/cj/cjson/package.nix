{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cjson";
  version = "1.7.19";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
