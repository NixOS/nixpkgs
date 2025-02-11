{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pandoc,
  pkg-config,
  doxygen,
  graphviz,
  libogg,
}:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "flac";
    tag = version;
    hash = "sha256-B6XRai5UOAtY/7JXNbI3YuBgazi1Xd2ZOs6vvLq9LIs=";
  };

  nativeBuildInputs = [
    cmake
    pandoc
    pkg-config
    doxygen
    graphviz
  ];

  buildInputs = [
    libogg
  ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isStatic) [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  CFLAGS = [
    "-O3"
    "-funroll-loops"
  ];
  CXXFLAGS = [ "-O3" ];

  # doCheck = true; # takes lots of time

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  meta = with lib; {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    changelog = "https://xiph.org/flac/changelog.html";
    mainProgram = "flac";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ruuda ];
  };
}
