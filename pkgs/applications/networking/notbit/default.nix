{ stdenv, fetchgit, autoconf, automake, pkgconfig, openssl }:

stdenv.mkDerivation rec {
  name = "notbit-git-faf0930";

  src = fetchgit {
    url = "git://github.com/bpeel/notbit";
    rev = "faf09304bf723e75f3d98cca93cf45236ee9d6b6";
    sha256 = "b229f87c4c5e901bfd8b13dffe31157126d98ed02118fff6553e8b58eb9ed030";
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
