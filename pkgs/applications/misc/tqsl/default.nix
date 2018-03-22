{ stdenv, fetchurl, makeWrapper, cmake, expat, openssl, zlib, db, curl, wxGTK }:

let
  lib_suffix =
  if stdenv.system == "x86_64-linux" then
    "64"
  else
    "";
in
stdenv.mkDerivation rec {
  name = "tqsl-${version}";
  version = "2.3.1";

  src = fetchurl {
    url = "http://www.arrl.org/files/file/LoTW%20Instructions/${name}.tar.gz";
    sha256 = "10cjlilampwl10hwb7m28m5z9gyrscvvc1rryfjnhj9q2x4ppgxv";
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

  patches = [ ./cmake_lib_path.patch ];

  meta = with stdenv.lib; {
    description = "Software for using the ARRL Logbook of the World";
    homepage = https://lotw.arrl.org/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dpflug ];
  };
}
