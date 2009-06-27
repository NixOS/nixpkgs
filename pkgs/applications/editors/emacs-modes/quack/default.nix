{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation {
  name = "quack-0.36";

  src = fetchurl {
    # XXX: Upstream URL is not versioned, which might eventually break this.
    url = "http://www.neilvandyke.org/quack/quack.el";
    sha256 = "0y9l35a8v56ldy4dap0816i80q9lnfpp27pl2a12d5hzb84hq8nr";
  };

  buildInputs = [ emacs ];

  builder = ./builder.sh;

  meta = {
    description = "Enhanced Emacs support for editing and running Scheme code";
    homepage = http://www.neilvandyke.org/quack/;
    license = "GPLv2+";
  };
}
