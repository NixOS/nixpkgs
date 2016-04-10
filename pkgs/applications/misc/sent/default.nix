{ stdenv, fetchurl, libpng, libX11, libXft
, patches ? [] }:

stdenv.mkDerivation rec {
  name = "sent-0.2";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0xhh752hwaa26k4q6wvrb9jnpbnylss2aw6z11j7l9rav7wn3fak";
  };

  buildInputs = [ libpng libX11 libXft ];

  inherit patches;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A simple plaintext presentation tool";
    homepage = http://tools.suckless.org/sent/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
