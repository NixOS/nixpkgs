{ stdenv, fetchurl, makeWrapper, cmake, expat, openssl, zlib, db, curl, wxGTK }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.5.1";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "00v4n8pvi5qi2psjnrw611w5gg5bdlaxbsny535fsci3smyygpc0";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cmake
    expat
    openssl
    zlib
    db
    curl
    wxGTK
  ];

  meta = with stdenv.lib; {
    description = "Software for using the ARRL Logbook of the World";
    homepage = https://www.arrl.org/tqsl-download;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dpflug ];
  };
}
