{ stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-${version}";
  version = "0.2.16a";

  src = fetchFromGitHub {
    owner = "fatbob313";
    repo = "umurmur";
    rev = version;
    sha256 = "1xv1knrivy2i0ggwrczw60y0ayww9df9k6sif7klgzq556xk47d1";
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
