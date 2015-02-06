{ stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-${version}";
  version = "0.2.15";
  
  src = fetchFromGitHub {
    owner = "fatbob313";
    repo = "umurmur";
    rev = version;
    sha256 = "0q0apnnb3pszhpsbadw52k6mhdc0hk38rk7vnn7dl4fsisfhgmx2";
  };
  
  buildInputs = [ autoreconfHook openssl protobufc libconfig ];

  configureFlags = "--with-ssl=openssl";

  meta = with stdenv.lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = http://code.google.com/p/umurmur/;
    platforms = platforms.all;
  };
}
