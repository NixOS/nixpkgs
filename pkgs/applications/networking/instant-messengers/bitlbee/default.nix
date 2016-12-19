{ fetchurl, fetchpatch, stdenv, gnutls, glib, pkgconfig, check, libotr, python }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-3.4.2";

  src = fetchurl {
    url = "mirror://bitlbee/src/${name}.tar.gz";
    sha256 = "0mza8lnfwibmklz8hdzg4f7p83hblf4h6fbf7d732kzpvra5bj39";
  };

  buildInputs = [ gnutls glib pkgconfig libotr python ]
    ++ optional doCheck check;

  configureFlags = [
    "--gcov=1"
    "--otr=1"
    "--ssl=gnutls"
    "--pidfile=/var/lib/bitlbee/bitlbee.pid"
  ];

  buildPhase = ''
    make install-dev
  '';

  doCheck = true;

  meta = {
    description = "IRC instant messaging gateway";

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
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ wkennington pSub ];
    platforms = platforms.gnu;  # arbitrary choice
  };
}
