{ lib, stdenv, fetchFromGitHub, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20220303";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-3fT9cHosg/A/JowIARQ46OxmsQWFOBb7tIiRWVNfUo4=";
  };

  # Remove when Apple SDK is >= 10.13
  patches = lib.optional (stdenv.system == "x86_64-darwin") ./apple-sdk-missing-utimensat.patch;

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
