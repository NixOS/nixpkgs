{ lib
, stdenv
, fetchFromGitHub
, boost182
, catch2_3
, cmake
, ninja
, fmt_9
, python3
}:

let
  # dependency for this library has been removed in master (i.e. next release)
  unordered_dense = stdenv.mkDerivation rec {
    version = "2.0.1";
    pname = "unordered_dense";
    src = fetchFromGitHub {
      owner = "martinus";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-9zlWYAY4lOQsL9+MYukqavBi5k96FvglRgznLIwwRyw=";
    };
    nativeBuildInputs = [
      cmake
    ];
  };

in
stdenv.mkDerivation rec {
  pname = "sv-lang";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    rev = "v${version}";
    sha256 = "sha256-v2sStvukLFMRXGeATxvizmnwEPDE4kwnS06n+37OrJA=";
  };

  cmakeFlags = [
    # fix for https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"

    "-DSLANG_INCLUDE_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  nativeBuildInputs = [
    cmake
    python3
    ninja

    # though only used in tests, cmake will complain its absence when configuring
    catch2_3
  ];

  buildInputs = [
    unordered_dense
    boost182
    fmt_9
  ];

  # TODO: a mysterious linker error occurs when building the unittests on darwin.
  # The error occurs when using catch2_3 in nixpkgs, not when fetching catch2_3 using CMake
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "SystemVerilog compiler and language services";
    homepage = "https://github.com/MikePopoloski/slang";
    license = licenses.mit;
    maintainers = with maintainers; [ sharzy ];
    mainProgram = "slang";
    platforms = platforms.all;
  };
}
