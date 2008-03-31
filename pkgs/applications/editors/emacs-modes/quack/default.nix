{ fetchurl, stdenv, emacs }:

stdenv.mkDerivation {
  name = "quack-0.30";

  src = fetchurl {
    # XXX: Upstream URL is not versioned, which might eventually break this.
    url = "http://www.neilvandyke.org/quack/quack.el";
    sha256 = "1j68azxbc54hdk3cw9q95qpz99wgj9xxgrzzwmydxh3zafy5faqs";
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
