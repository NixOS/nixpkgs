{ lib, stdenv, fetchurl, openssl, python3 }:

stdenv.mkDerivation rec {
  pname = "fetchmail";
  version = "6.4.35";

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail/fetchmail-${version}.tar.xz";
    sha256 = "sha256-ewtWy8D8qFRQTxZ3lfq1MtWlTVp9O24+NqM/NKCWCgE=";
  };

  buildInputs = [ openssl python3 ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = with lib; {
    homepage = "https://www.fetchmail.info/";
    description = "A full-featured remote-mail retrieval and forwarding utility";
    longDescription = ''
      A full-featured, robust, well-documented remote-mail retrieval and
      forwarding utility intended to be used over on-demand TCP/IP links
      (such as SLIP or PPP connections). It supports every remote-mail
      protocol now in use on the Internet: POP2, POP3, RPOP, APOP, KPOP,
      all flavors of IMAP, ETRN, and ODMR. It can even support IPv6 and
      IPSEC.
    '';
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
