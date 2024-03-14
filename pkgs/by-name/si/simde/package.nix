{ stdenv, lib, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "simde";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "v${version}";
    hash = "sha256-hQtSxO8Uld6LT6V1ZhR6tbshTK1QTGgyQ99o3jOIbQk=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib; {
    homepage = "https://simd-everywhere.github.io";
    description = "Implementations of SIMD instruction sets for systems which don't natively support them";
    license = with licenses; [mit];
    maintainers = with maintainers; [ whiteley ];
    platforms = flatten (with platforms; [
      arm
      armv7
      aarch64
      x86
      power
      mips
    ]);
  };
}
