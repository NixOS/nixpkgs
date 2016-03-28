{ fetchurl, fetchpatch, stdenv, gnutls, glib, pkgconfig, check, libotr, python }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-3.4.1";

  src = fetchurl {
    url = "mirror://bitlbee/src/${name}.tar.gz";
    sha256 = "1qf0ypa9ba5jvsnpg9slmaran16hcc5fnfzbb1sdch1hjhchn2jh";
  };

  buildInputs = [ gnutls glib pkgconfig libotr python ]
    ++ optional doCheck check;

  patches = [(fetchpatch {
    url = "https://github.com/bitlbee/bitlbee/commit/34d16d5b4b5265990125894572a90493284358cd.patch";
    sha256 = "05in9kxabb6s2c1l4b9ry58ppfciwmwzrkaq33df2zv0pr3z7w33";
  })];

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
