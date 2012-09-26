{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.40";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el.cgi;
    sha256 = "1v7pzif5b7dr6iyllqvzka8i6s23rsjdnmilnma054gv8d4shw6a";
  };

  meta = {
    description = "Convert buffer text and decorations to HTML.";
  };
}
