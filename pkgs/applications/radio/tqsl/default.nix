{ lib, stdenv, fetchurl, makeWrapper, cmake, expat, openssl, zlib, db, curl, wxGTK }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.5.9";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "sha256-flv7tI/SYAxxJsHFa3QUgnO0glAAQF87EgP4wyTWnNU=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [
    expat
    openssl
    zlib
    db
    (curl.override { inherit openssl; })
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
