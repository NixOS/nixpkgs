{
  lib,
  stdenv,
  fetchurl,
  cmake,
  expat,
  openssl,
  zlib,
  lmdb,
  curl,
  sqlite,
  wxGTK32,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "tqsl";
  version = "2.7.3";

  src = fetchurl {
    url = "https://www.arrl.org/files/file/LoTW%20Instructions/${pname}-${version}.tar.gz";
    sha256 = "sha256-Ca9PsytjPvrU4u+b/x6pIbQc8CDNWI6hNM6jF60Bds8=";
  };

  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
  ];
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
    mainProgram = "tqsl";
    homepage = "https://www.arrl.org/tqsl-download";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dpflug ];
  };
}
