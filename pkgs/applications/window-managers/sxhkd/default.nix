{ stdenv, fetchurl, asciidoc, libxcb, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "sxhkd-${version}";
  version = "0.5.5";

  src = fetchurl {
    url = "https://github.com/baskerville/sxhkd/archive/${version}.tar.gz";
    sha256 = "04s3y2bq9502gw72jj3y2zsh96yj3qg2av3zsa8ahd2farvrysg6";
  };

  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = ''PREFIX=$(out)'';

  meta = {
    description = "Simple X hotkey daemon";
    homepage = http://github.com/baskerville/sxhkd/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
