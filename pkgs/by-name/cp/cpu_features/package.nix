{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "cpu_features";
  version = "0.10.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "cpu_features";
    rev = "v${version}";
    hash = "sha256-IBJc1sHHh4G3oTzQm1RAHHahsEECC+BDl14DHJ8M1Ys=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}" ];

  meta = with lib; {
    description = "Cross platform C99 library to get cpu features at runtime";
    homepage = "https://github.com/google/cpu_features";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ renesat ];
  };
}
