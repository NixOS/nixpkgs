{ stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  name = "umurmur-${version}";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    rev = version;
    sha256 = "074px4ygmv4ydy2pqwxwnz17f0hfswqkz5kc9qfz0iby3h5i3fyl";
  };

  buildInputs = [ autoreconfHook openssl protobufc libconfig ];

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  meta = with stdenv.lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = https://github.com/umurmur/umurmur;
    platforms = platforms.all;
  };
}
