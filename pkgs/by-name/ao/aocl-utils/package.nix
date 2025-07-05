{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "aocl-utils";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-utils";
    tag = version;
    hash = "sha256-1g5gERVxXKAeCyNR9/HheUfj+MPxJso3NzqDonvuyMo=";
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
