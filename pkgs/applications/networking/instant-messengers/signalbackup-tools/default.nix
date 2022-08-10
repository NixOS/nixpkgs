{ lib, stdenv, fetchFromGitHub, fetchpatch, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20220810";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-z/RAvNUss9rNuBQvxjJQl66ZMrlxvmS9at8L/vSG0XU=";
  };

  patches = [
    (fetchpatch {
      name = "fix-platform-checks.patch";
      url = "https://github.com/bepaald/signalbackup-tools/compare/20220810..a81baf25b6ba63da7d30d9a239e5b4bbc8d1ab4f.patch";
      sha256 = "sha256-i7fuPBil8zB+V3wHHdcbmP79OZoTfG2ZpXPQ3m7X06c=";
    })
  ];

  buildInputs = [ openssl sqlite ];
  buildFlags = [
    "-Wall"
    "-Wextra"
    "-Wshadow"
    "-Wold-style-cast"
    "-Woverloaded-virtual"
    "-pedantic"
    "-std=c++2a"
    "-O3"
    "-march=native"
  ];
  buildPhase = ''
    $CXX $buildFlags */*.cc *.cc -lcrypto -lsqlite3 -o signalbackup-tools
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
