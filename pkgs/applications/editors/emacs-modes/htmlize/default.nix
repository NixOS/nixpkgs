{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.37";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el;
    sha256 = "17sbhf4r6jh4610x8qb2y0y3hww7w33vfsjqg4vrz99pr29xffry";
  };

  meta = {
    description = "Convert buffer text and decorations to HTML.";
  };
}
