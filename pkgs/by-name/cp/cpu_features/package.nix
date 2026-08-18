{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpu_features";
  version = "0.10.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "cpu_features";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IBJc1sHHh4G3oTzQm1RAHHahsEECC+BDl14DHJ8M1Ys=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}" ];

  meta = {
    description = "Cross platform C99 library to get cpu features at runtime";
    homepage = "https://github.com/google/cpu_features";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ renesat ];
  };
})
