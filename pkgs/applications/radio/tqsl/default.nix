{ lib, stdenv, fetchurl, cmake, expat, openssl, zlib, lmdb, curl, sqlite, wxGTK32, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.7.2";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "sha256-T4NBCUTYHT6ugSg1gSfjQBOBndqwSwyWLr/qlDPQGKI=";
  };

  nativeBuildInputs = [ cmake wrapGAppsHook ];
  buildInputs = [
    expat
    openssl
    zlib
    lmdb
    curl
    sqlite
    wxGTK32
  ];

  meta = with lib; {
    description = "Software for using the ARRL Logbook of the World";
    homepage = "https://www.arrl.org/tqsl-download";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dpflug ];
  };
}
