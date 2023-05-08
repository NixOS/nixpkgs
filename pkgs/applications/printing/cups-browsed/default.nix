{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, cups
, libcupsfilters
, libppd
, glib
, libresolv
, withAvahi ? true
, avahi
, withLDAP ? true
, openldap
}:

stdenv.mkDerivation rec {
  pname = "cups-browsed";
  version = "2.0b2";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-browsed";
    rev = version;
    hash = "sha256-IJMavKZVNmniHNC6XbffoP6UzFD9wgzRAKrdsGsrH4E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [
    cups
    glib
    libppd
    libcupsfilters
  ] ++ lib.optionals withAvahi [ avahi ]
    ++ lib.optionals withLDAP [ openldap ]
    ++ lib.optionals stdenv.isDarwin [ libresolv ];

  # From weechat:
  # Fix '_res_9_init: undefined symbol' error
  CFLAGS = lib.optionalString stdenv.isDarwin "-DBIND_8_COMPAT=1 -lresolv";

  configureFlags = [ "--with-rcdir=no" ]
    ++ lib.optionals (!withAvahi) [ "--disable-avahi" ]
    ++ lib.optionals (!withLDAP) [ "--disable-ldap" ];

  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];

  meta = with lib; {
    description = "Helper daemon to browse the network for remote CUPS queues and IPP network printers";
    homepage = "https://github.com/OpenPrinting/cups-browsed";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkus ];
    platforms = platforms.unix;
  };
}

