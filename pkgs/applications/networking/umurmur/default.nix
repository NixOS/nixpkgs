{ stdenv, fetchurl, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-0.2.13";
  
  src = fetchurl {
    url = "http://umurmur.googlecode.com/files/${name}.tar.gz";
    sha1 = "c9345b67213f52688fef2113132c62d2edbf4bea";
  };
  
  buildInputs = [ openssl protobufc libconfig ];

  configureFlags = "--with-ssl=openssl";

  meta = with stdenv.lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = http://code.google.com/p/umurmur/;
  };
}
