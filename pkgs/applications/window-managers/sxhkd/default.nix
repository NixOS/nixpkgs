{ stdenv, fetchurl, asciidoc, libxcb, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "sxhkd-${version}";
  version = "0.5.6";

  src = fetchurl {
    url = "https://github.com/baskerville/sxhkd/archive/${version}.tar.gz";
    sha256 = "15grmzpxz5fqlbfg2slj7gb7r6nzkvjmflmbkqx7mlby9pm6wdkj";
  };

  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = ''PREFIX=$(out)'';

  meta = with stdenv.lib; {
    description = "Simple X hotkey daemon";
    homepage = "https://github.com/baskerville/sxhkd";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
