{ stdenv, fetchurl, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-0.2.12";
  
  src = fetchurl {
    url = "http://umurmur.googlecode.com/files/${name}.tar.gz";
    sha1 = "5be3c765af3c5f518d1e1bbd828b3582ad4097cd";
  };
  
  buildInputs = [ openssl protobufc libconfig ];

  configureFlags = "--with-ssl=openssl";

  meta = {
    description = "Minimalistic Murmur (Mumble server)";
    license = "BSD";
    homepage = http://code.google.com/p/umurmur/;
  };
}
