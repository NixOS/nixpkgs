{ stdenv, fetchgit, autoconf, automake, pkgconfig, openssl }:

stdenv.mkDerivation rec {
  name = "notbit-0.2-28-g06f9160";

  src = fetchgit {
    url = "git://git.busydoingnothing.co.uk/notbit";
    rev = "06f916081836de12f8e57a9f50c95d4d1b51627f";
    sha256 = "d5c38eea1d9ca213bfbea5c88350478a5088b5532e939de9680d72e60aa65288";
  };

  buildInputs = [ autoconf automake pkgconfig openssl ];

  preConfigure = "autoreconf -vfi";

  meta = with stdenv.lib; { 
    homepage = http://busydoingnothing.co.uk/notbit/;
    description = "A minimal bitmessage client";
    license = licenses.mit;

    # This is planned to change when the project officially supports other platforms
    platforms = platforms.linux;
  };
}
