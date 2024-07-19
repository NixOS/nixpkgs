{ lib
, stdenv
, fetchFromGitHub
, boost182
, catch2_3
, cmake
, ninja
, fmt_10
, python3
}:

stdenv.mkDerivation rec {
  pname = "sv-lang";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    rev = "v${version}";
    hash = "sha256-mT8sfUz0H4jWM/SkV/uW4kmVKE9UQy6XieG65yJvIA8=";
  };

  cmakeFlags = [
    # fix for https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

    "-DSLANG_INCLUDE_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DSLANG_USE_MIMALLOC=OFF"
  ];

  nativeBuildInputs = [
    cmake
    python3
    ninja

    # though only used in tests, cmake will complain its absence when configuring
    catch2_3
  ];

  buildInputs = [
    boost182
    fmt_10
  ];

  doCheck = true;

  meta = with lib; {
    description = "SystemVerilog compiler and language services";
    homepage = "https://github.com/MikePopoloski/slang";
    license = licenses.mit;
    maintainers = with maintainers; [ sharzy ];
    mainProgram = "slang";
    platforms = platforms.all;
  };
}
