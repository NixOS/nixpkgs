{ stdenv, fetchFromGitHub, asciidoc, libxcb, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "sxhkd-git-2016-08-29";

  src = fetchFromGitHub {
    owner  = "baskerville";
    repo   = "sxhkd";
    rev    = "69b6acc7831bd333b39286c37188e5638ad0de27";
    sha256 = "11i451hz0icsbxnvbq2bdl6r5kacxf6ps0yvi9ix3vkpxn4zcanh";
  };

  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = ''PREFIX=$(out)'';

  meta = {
    description = "Simple X hotkey daemon (git version)";
    homepage = http://github.com/baskerville/sxhkd/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
{
  "url": "https://github.com/baskerville/sxhkd",
  "date": "2016-08-29T20:45:21+02:00",
}
