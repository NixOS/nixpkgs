{ stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-${version}";
  version = "0.2.16";
  
  src = fetchFromGitHub {
    owner = "fatbob313";
    repo = "umurmur";
    rev = version;
    sha256 = "0njvdqvjda13v1a2yyjn47mb0l0cdfb2bfvb5s13wpgwy2xxk0px";
  };
  
  buildInputs = [ autoreconfHook openssl protobufc libconfig ];

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  meta = with stdenv.lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = http://code.google.com/p/umurmur/;
    platforms = platforms.all;
  };
}
