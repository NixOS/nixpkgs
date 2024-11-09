{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cups,
  libcupsfilters,
  libppd,
  glib,
  libresolv,
  withAvahi ? true,
  avahi,
  withLDAP ? true,
  openldap,
}:

stdenv.mkDerivation rec {
  pname = "cups-browsed";
  version = "2.0.1-1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-browsed";
    rev = "1d1072a0de573b7850958df614e9ec5b73ea0e0d";
    hash = "sha256-jT8sBKKU/dVAWecDdU5BqdaUZcd0vKvg9gJ9bQ6FBIg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      cups
      glib
      libppd
      libcupsfilters
    ]
    ++ lib.optionals withAvahi [ avahi ]
    ++ lib.optionals withLDAP [ openldap ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libresolv ];

  # From weechat:
  # Fix '_res_9_init: undefined symbol' error
  CFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-DBIND_8_COMPAT=1 -lresolv";

  configureFlags = [
    "--with-rcdir=no"
    (lib.enableFeature withAvahi "avahi")
    (lib.enableFeature withLDAP "ldap")
  ];

  makeFlags = [
    "CUPS_SERVERBIN=${placeholder "out"}/lib/cups"
    "CUPS_DATADIR=${placeholder "out"}/share/cups"
    "CUPS_SERVERROOT=${placeholder "out"}/etc/cups"
  ];

  meta = with lib; {
    description = "Helper daemon to browse the network for remote CUPS queues and IPP network printers";
    homepage = "https://github.com/OpenPrinting/cups-browsed";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkus ];
    platforms = platforms.unix;
  };
}
