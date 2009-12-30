{ fetchurl, stdenv, gnutls, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "bitlbee-1.2.4";

  src = fetchurl {
    url = "mirror://bitlbee/src/" + name + ".tar.gz";
    sha256 = "1lwcjh1r81xqf6fxjwd2a2hv8dq9g0iyc8dnbr1pgas4vmjg9xf2";
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
