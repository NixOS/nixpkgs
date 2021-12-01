{ lib, stdenv, fetchurl, makeWrapper, cmake, expat, openssl, zlib, db, curl, wxGTK }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.5.7";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "sha256-0QlTUNwKeuuR+n8eT04kiywAsY3hrPGPYH1A84MmxIs=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    expat
    openssl
    zlib
    db
    curl
    wxGTK
  ];

  meta = with lib; {
    description = "Software for using the ARRL Logbook of the World";
    homepage = "https://www.arrl.org/tqsl-download";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dpflug ];
  };
}
