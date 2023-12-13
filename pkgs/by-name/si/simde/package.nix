{ stdenv, lib, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "simde";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "v${version}";
    hash = "sha256-pj+zaD5o9XYkTavezcQFzM6ao0IdQP1zjP9L4vcCyEY=";
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
