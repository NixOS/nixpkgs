{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "fast-float";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "fastfloat";
    repo = "fast_float";
    rev = "v${version}";
    hash = "sha256-zHSLoGhlKkF0PP7TQNUzgv2Qn3yeBR5hqQ8X5lxoUeg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Fast and exact implementation of the C++ from_chars functions for float and double types: 4x to 10x faster than strtod, part of GCC 12 and WebKit/Safari";
    homepage = "https://github.com/fastfloat/fast_float";
    license = with licenses; [ asl20 boost mit ];
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "fast-float";
    platforms = platforms.all;
  };
}
