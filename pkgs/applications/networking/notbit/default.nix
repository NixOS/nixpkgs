{ stdenv, fetchgit, autoconf, automake, pkgconfig, openssl }:

stdenv.mkDerivation rec {
  name = "notbit-git-6f1ca59";

  src = fetchgit {
    url = "git://github.com/bpeel/notbit";
    rev = "6f1ca5987c7f217c9c3dd27adf6ac995004c29a1";
    sha256 = "0h9nzm248pw9wrdsfkr580ghiqvh6mk6vx7r2r752awrc13wvgis";
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
