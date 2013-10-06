{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.47";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el.cgi;
    sha256 = "0m7lby95w9sj0xlqv39imlbp80x8ajd295cs6079jyhmryf6mr10";
  };

  meta = {
    description = "Convert buffer text and decorations to HTML";
  };
}
