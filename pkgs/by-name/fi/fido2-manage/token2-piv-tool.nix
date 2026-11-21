{
  lib,
  stdenv,
  cmake,
  pkg-config,
  gengetopt,
  help2man,
  openssl,
  pcsclite,
  zlib,
  check,
  src,
  version,
}:
stdenv.mkDerivation {
  pname = "token2-piv-tool";
  inherit src version;

  sourceRoot = "source/token2-piv-tool";

  nativeBuildInputs = [
    cmake
    pkg-config
    gengetopt
    help2man
  ];
  buildInputs = [
    openssl
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux pcsclite;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "-Werror" ""

    # The fork changed this hex input but retained the original expected bytes.
    substituteInPlace lib/tests/parse_key.c \
      --replace-fail '865362865362865362865362865362865362865362865362' \
        '010203040506070801020304050607080102030405060708'
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_STATIC_LIB" false)
    (lib.cmakeBool "ENABLE_HARDWARE_TESTS" false)
    (lib.cmakeBool "GENERATE_MAN_PAGES" true)
    (lib.cmakeFeature "BACKEND" (if stdenv.hostPlatform.isDarwin then "macscard" else "pcsc"))
  ];

  doCheck = true;
  nativeCheckInputs = [ check ];

  meta = {
    description = "PIV tools and libraries for Token2 security keys";
    homepage = "https://github.com/token2/fido2-manage";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
