{ stdenv, fetchurl, fetchpatch, pkgconfig, ncurses, readline, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "abook-0.6.1";

  src = fetchurl {
    url = "http://abook.sourceforge.net/devel/${name}.tar.gz";
    sha256 = "1yf0ifyjhq2r003pnpn92mn0924bn9yxjifxxj2ldcsgd7w0vagh";
  };

  patches = [
    (fetchpatch {
       url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/gcc5.patch?h=packages/abook";
       name = "gcc5.patch";
       sha256 = "13n3qd6yy45i5n8ppjn9hj6y63ymjrq96280683xk7f7rjavw5nn";
     })
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ ncurses readline ];

  meta = {
    homepage = "http://abook.sourceforge.net/";
    description = "Text-based addressbook program designed to use with mutt mail client";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
