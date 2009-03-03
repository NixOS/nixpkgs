{stdenv, fetchurl, emacs, texinfo, ctags}:

stdenv.mkDerivation {
  name = "bbdb-2.35";

  src = fetchurl {
    url = http://bbdb.sourceforge.net/bbdb-2.35.tar.gz;
    sha256 = "3fb1316e2ed74d47ca61187fada550e58797467bd9e8ad67343ed16da769f916";
  };

  patches = [ ./install-infodir.patch ];

  buildInputs = [emacs texinfo ctags];
  builder = ./builder.sh;

  meta = {
    description = "The Insidious Big Brother Database (BBDB), a contact management utility for Emacs";
    homepage = http://bbdb.sourceforge.net/;
    license = "GPL";
  };
}
