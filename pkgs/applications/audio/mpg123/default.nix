{stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation {
  name = "mpg123-1.14.4";

  src = fetchurl {
    url = mirror://sourceforge/mpg123/mpg123-1.14.4.tar.bz2;
    sha256 = "04jw7sfnmk853awviq8c63mdk7s3r31p4kdn8r86pv5l9vr8k8cw";
  };

  buildInputs = [ alsaLib ];

  crossAttrs = {
    configureFlags = if stdenv.cross ? mpg123 then
      "--with-cpu=${stdenv.cross.mpg123.cpu}" else "";
  };

  meta = {
    description = "Command-line MP3 player";
    homepage = http://mpg123.sourceforge.net/;
    license = "LGPL";
  };
}
