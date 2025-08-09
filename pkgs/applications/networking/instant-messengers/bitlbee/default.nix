{
  lib,
  fetchurl,
  fetchpatch,
  stdenv,
  gnutls,
  glib,
  pkg-config,
  check,
  libotr,
  python3,
  enableLibPurple ? false,
  pidgin ? null,
  enablePam ? false,
  pam ? null,
}:

stdenv.mkDerivation rec {
  pname = "bitlbee";
  version = "3.6";

  src = fetchurl {
    url = "mirror://bitlbee/src/bitlbee-${version}.tar.gz";
    sha256 = "0zhhcbcr59sx9h4maf8zamzv2waya7sbsl7w74gbyilvy93dw5cz";
  };

  nativeBuildInputs = [ pkg-config ] ++ lib.optional doCheck check;

  buildInputs = [
    gnutls
    libotr
    python3
  ]
  ++ lib.optional enableLibPurple pidgin
  ++ lib.optional enablePam pam;

  propagatedBuildInputs = [ glib ];

  configureFlags = [
    "--otr=1"
    "--ssl=gnutls"
    "--pidfile=/var/lib/bitlbee/bitlbee.pid"
  ]
  ++ lib.optional enableLibPurple "--purple=1"
  ++ lib.optional enablePam "--pam=1";

  patches = [
    # This should be dropped once the issue is fixed upstream.
    (fetchpatch {
      url = "https://github.com/bitlbee/bitlbee/commit/6ff651b3ec93e5fd74f80766d5e9714d963137bc.diff";
      sha256 = "144dpm4kq7c268fpww1q3n88ayg068n73fbabr5arh1zryw48qfv";
    })
  ];

  installTargets = [
    "install"
    "install-dev"
  ];

  doCheck = !enableLibPurple; # Checks fail with libpurple for some reason
  checkPhase = ''
    # check flags set VERBOSE=y which breaks the build due overriding a command
    make check
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "IRC instant messaging gateway";
    mainProgram = "bitlbee";

    longDescription = ''
      BitlBee brings IM (instant messaging) to IRC clients.  It's a
      great solution for people who have an IRC client running all the
      time and don't want to run an additional MSN/AIM/whatever
      client.

      BitlBee currently supports the following IM networks/protocols:
      XMPP/Jabber (including Google Talk), MSN Messenger, Yahoo!
      Messenger, AIM and ICQ.
    '';

    homepage = "https://www.bitlbee.org/";
    license = licenses.gpl2Plus;

    maintainers = with maintainers; [
      lassulus
      pSub
    ];
    platforms = platforms.gnu ++ platforms.linux; # arbitrary choice
  };
}
