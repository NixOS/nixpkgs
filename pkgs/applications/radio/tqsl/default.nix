{ lib, stdenv, fetchurl, cmake, expat, openssl, zlib, lmdb, curl, wxGTK32, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.6.5";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "sha256-UGPMp1mAarHWuLbZu2wWpjgCdf8ZKj0Mwkqp32U5/8w=";
  };

  nativeBuildInputs = [ cmake wrapGAppsHook ];
  buildInputs = [
    expat
    openssl
    zlib
    lmdb
    (curl.override { inherit openssl; })
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
