{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "htmlize-1.37";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el.cgi;
    sha256 = "70cf41a2ea6a478a45143a8cd672381c01ed894448200e602531acbf2b1fd160";
  };

  meta = {
    description = "Convert buffer text and decorations to HTML.";
  };
}
