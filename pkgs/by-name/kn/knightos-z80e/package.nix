{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  knightos-scas,
  readline,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "z80e";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "z80e";
    rev = version;
    sha256 = "sha256-FQMYHxKxHEP+x98JbGyjaM0OL8QK/p3epsAWvQkv6bc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    readline
    SDL2
    knightos-scas
  ];

  cmakeFlags = [ "-Denable-sdl=YES" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace libz80e/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace frontends/libz80e/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "https://knightos.org/";
    description = "Z80 calculator emulator and debugger";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
