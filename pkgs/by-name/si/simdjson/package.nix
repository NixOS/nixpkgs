{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "simdjson";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    rev = "v${version}";
    sha256 = "sha256-sS/H8nG1mZLHZvhFWl6UcsMvDcmcPh9+X0uEhEdNuic=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    [
      "-DSIMDJSON_DEVELOPER_MODE=OFF"
    ]
    ++ lib.optionals stdenv.hostPlatform.isStatic [
      "-DBUILD_SHARED_LIBS=OFF"
    ]
    ++ lib.optionals (with stdenv.hostPlatform; isPower && isBigEndian) [
      # Assume required CPU features are available, since otherwise we
      # just get a failed build.
      "-DCMAKE_CXX_FLAGS=-mpower8-vector"
    ];

  meta = with lib; {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ chessai ];
  };
}
