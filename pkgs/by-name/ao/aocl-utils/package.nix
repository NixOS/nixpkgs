{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "aocl-utils";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-utils";
    rev = version;
    hash = "sha256-96j3Sw+Ts+CZzjPpUlt8cRYO5z0iASo+W/x1nrrAyQE=";
  };

  patches = [ ./pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "AU_BUILD_STATIC_LIBS" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "AU_BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = with lib; {
    description = "Interface to all AMD AOCL libraries to access CPU features";
    homepage = "https://github.com/amd/aocl-utils";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.markuskowa ];
  };
}
