{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "libcue";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${version}";
    hash = "sha256-ZMUUa8CmpFNparPsM/P2yvRto9E85EdTxpID5sKQbNI=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)'
  '';

  doCheck = true;

  meta = with lib; {
    description = "CUE Sheet Parser Library";
    longDescription = ''
      libcue is intended to parse a so called cue sheet from a char string or
      a file pointer. For handling of the parsed data a convenient API is
      available.
    '';
    homepage = "https://github.com/lipnitsk/libcue";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
