{
  lib,
  stdenv,
  fetchurl,
  openssl,
  python3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetchmail";
  version = "6.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail/fetchmail-${finalAttrs.version}.tar.xz";
    hash = "sha256-pRCSlewzGeDkXt0AnS2XcEKoMmq1LGqBeoL6mHED5PM=";
  };

  buildInputs = [
    openssl
    python3
  ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = {
    homepage = "https://www.fetchmail.info/";
    description = "Full-featured remote-mail retrieval and forwarding utility";
    longDescription = ''
      A full-featured, robust, well-documented remote-mail retrieval and
      forwarding utility intended to be used over on-demand TCP/IP links
      (such as SLIP or PPP connections). It supports every remote-mail
      protocol now in use on the Internet: POP2, POP3, RPOP, APOP, KPOP,
      all flavors of IMAP, ETRN, and ODMR. It can even support IPv6 and
      IPSEC.
    '';
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "fetchmail";
  };
})
