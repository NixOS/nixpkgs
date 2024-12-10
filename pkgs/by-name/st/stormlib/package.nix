{
  lib,
  bzip2,
  cmake,
  darwin,
  fetchFromGitHub,
  libtomcrypt,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stormlib";
  version = "9.23";

  src = fetchFromGitHub {
    owner = "ladislav-zezula";
    repo = "StormLib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8JDMqZ5BWslH4+Mfo5lnWTmD2QDaColwBOLzcuGZciY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      bzip2
      libtomcrypt
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Carbon
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "WITH_LIBTOMCRYPT" true)
  ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-implicit-function-declaration"
      "-Wno-int-conversion"
    ]
  );

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "FRAMEWORK DESTINATION /Library/Frameworks" "FRAMEWORK DESTINATION Library/Frameworks"
  '';

  meta = {
    homepage = "https://github.com/ladislav-zezula/StormLib";
    description = "An open-source project that can work with Blizzard MPQ archives";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aanderse
      karolchmist
    ];
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin; # installation directory mismatch
  };
})
