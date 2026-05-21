{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aocl-utils";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-utils";
    tag = finalAttrs.version;
    hash = "sha256-grEuYM+Ss4pQQ12S5uOV27ocVHzYuLK+e70Jm5u8fuI=";
  };

  patches = [ ./pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "AU_BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "AU_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    description = "Interface to all AMD AOCL libraries to access CPU features";
    homepage = "https://github.com/amd/aocl-utils";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
