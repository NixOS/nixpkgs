{ stdenv, fetchFromGitHub, adns, boehmgc, openssl, automake, m4, autoconf
, libtool, pkgconfig }:

stdenv.mkDerivation {
  name = "gale-1.1happy";

  src = fetchFromGitHub {
    owner = "grawity";
    repo = "gale";
    rev = "b34a67288e8bd6f0b51b60abb704858172a3665c";
    sha256 = "19mcisxxqx70m059rqwv7wpmp94fgyckzjwywpmdqd7iwvppnsqf";
  };

  nativeBuildInputs = [ m4 libtool automake autoconf ];
  buildInputs = [ boehmgc openssl adns pkgconfig ];

  patches = [ ./gale-install.in.patch ];

  preConfigure = ''
    substituteInPlace configure.ac --replace \$\{sysconfdir\} /etc
    ./bootstrap
  '';
  configureArgs = [ "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    homepage = "http://gale.org/";
    description = "Chat/messaging system (server and client)";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
