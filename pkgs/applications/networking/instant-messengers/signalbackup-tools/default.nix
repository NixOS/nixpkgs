{ lib, stdenv, fetchFromGitHub, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20220711";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-dKU8oTQ6ECwycDN3k7NY/pKpNWH16ceJIFDnRNEA90c=";
  };

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
