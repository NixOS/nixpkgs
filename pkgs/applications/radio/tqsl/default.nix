{ stdenv, fetchurl, makeWrapper, cmake, expat, openssl, zlib, db, curl, wxGTK }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.4.3";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "0f8pa5wnp0x0mjjr5kanka9hirgmp5wf6jsb95dc6hjlzlvy6kz9";
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
