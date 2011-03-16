{ fetchurl, stdenv, gnutls, glib, pkgconfig, check, libotr }:

stdenv.mkDerivation rec {
  name = "bitlbee-3.0.1";

  src = fetchurl {
    url = "mirror://bitlbee/src/${name}.tar.gz";
    sha256 = "027n5f0phjr5fcrphbcflqv8hlkv5qnrpc1xgr09qjyv6mxp72j0";
  };

  buildInputs = [ gnutls glib pkgconfig libotr ]
    ++ stdenv.lib.optional doCheck check;

  configureFlags = [ "--otr=1" ];

  preCheck = "mkdir tests/.depend";
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
