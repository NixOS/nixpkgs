{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.43";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el.cgi;
    sha256 = "0bdaxh3pjf4z55i7vz4yz3yz45720h8aalhmx13bgkrpijzn93bi";
  };

  meta = {
    description = "Convert buffer text and decorations to HTML.";
  };
}
