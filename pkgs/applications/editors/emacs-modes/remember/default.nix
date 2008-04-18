{ fetchurl, stdenv, texinfo, emacs, bbdb }:

stdenv.mkDerivation rec {
  name = "remember-2.0";
  src = fetchurl {
    url = "http://download.gna.org/remember-el/${name}.tar.gz";
    sha256 = "04bp071xjbb6mbspjpwcza0krgx2827v6rfxbsdcpn0qcjgad9wm";
  };

  buildInputs = [ emacs texinfo ];

  patchPhase = ''
    sed -i "Makefile.defs" -"es|^PREFIX *=.*$|PREFIX = $out|g"
  '';

  meta = {
    description = "Remember, an Emacs mode for quickly remembering data";

    longDescription = ''
      Remember is an Emacs mode for quickly remembering data.  It uses
      whatever back-end is appropriate to record and correlate the
      data, but its main intention is to allow you to express as
      little structure as possible up front.

      When you enter data, either by typing it into a buffer, or using
      the contents of the selected region, Remember will store that
      data -- unindexed, uninterpreted -- in a data pool.  It will
      also try to remember as much context information as possible
      (any text properties that were set, where you copied it from,
      when, how, etc).  Later, you can walk through your accumulated
      set of data (both organized, and unorganized) and easily begin
      moving things around, and making annotations that will express
      the full meaning of that data, as far as you know it.
    '';

    homepage = http://gna.org/projects/remember-el/;
    license = "GPLv2+";
  };
}
