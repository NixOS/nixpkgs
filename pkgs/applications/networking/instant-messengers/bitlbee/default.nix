{ fetchurl, stdenv, gnutls, glib, pkgconfig, check }:

stdenv.mkDerivation rec {
  name = "bitlbee-1.2.8";

  src = fetchurl {
    url = "mirror://bitlbee/src/${name}.tar.gz";
    sha256 = "11lfxvra46mwcnlxvhnywv6xbp7zl3h27hsbfwdh16b6fy41n1is";
  };

  buildInputs = [ gnutls glib pkgconfig ]
    ++ stdenv.lib.optional doCheck check;

  doCheck = true;

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
