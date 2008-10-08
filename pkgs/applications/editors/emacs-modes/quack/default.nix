{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation {
  name = "quack-0.30";

  src = fetchurl {
    # XXX: Upstream URL is not versioned, which might eventually break this.
    url = "http://www.neilvandyke.org/quack/quack.el";
    sha256 = "1xmpbdb064s3l3cv4agf03ir1g7xfzyvlqayr3yy5f8z3i6pf7mi";
  };

  buildInputs = [ emacs ];

  builder = ./builder.sh;

  meta = {
    description = ''Quack: Enhanced Emacs Support for Editing and
                    Running Scheme Code'';
    homepage = http://www.neilvandyke.org/quack/;
    license = "GPLv2+";
  };
}
