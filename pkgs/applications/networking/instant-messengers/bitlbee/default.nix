{ fetchurl, stdenv, gnutls, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "bitlbee-1.2.3";

  src = fetchurl {
    url = "mirror://bitlbee/src/" + name + ".tar.gz";
    sha256 = "1qj5cx0lqhg6dy2gdjb05ap963r84rv1b96iz23c97c2ihc31fqc";
  };

  buildInputs = [ gnutls glib pkgconfig ];

  meta = {
    description = "BitlBee, an IRC to other chat networks gateway";

    longDescription = ''
      BitlBee brings IM (instant messaging) to IRC clients.  It's a
      great solution for people who have an IRC client running all the
      time and don't want to run an additional MSN/AIM/whatever
      client.

      BitlBee currently supports the following IM networks/protocols:
      XMPP/Jabber (including Google Talk), MSN Messenger, Yahoo!
      Messenger, AIM and ICQ.
    '';

    homepage = http://www.bitlbee.org/;
    license = "GPLv2+";
  };
}
