{ stdenv, fetchurl, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-0.2.10";
  
  src = fetchurl {
    url = "http://umurmur.googlecode.com/files/${name}.tar.gz";
    sha256 = "0c990jvm73a6lajr1qlzw0p6nkshkh2nqwjmz2sq79pj0hm9ckvy";
  };
  
  buildInputs = [ openssl protobufc libconfig ];

  configureFlags = "--with-ssl=openssl";

  meta = {
    description = "Minimalistic Murmur (Mumble server)";
    license = "BSD";
    homepage = http://code.google.com/p/umurmur/;
  };
}
