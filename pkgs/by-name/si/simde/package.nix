{ stdenv, lib, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "simde";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "simd-everywhere";
    repo = "simde";
    rev = "v${version}";
    hash = "sha256-igjDHCpKXy6EbA9Mf6peL4OTVRPYTV0Y2jbgYQuWMT4=";
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
      riscv
    ]);
  };
}
