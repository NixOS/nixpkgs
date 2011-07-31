{ stdenv, fetchurl, openssl }:

let
  version = "6.3.20";
in
stdenv.mkDerivation {
  name="fetchmail-${version}";

  src = fetchurl {
    url = "http://download.berlios.de/fetchmail/fetchmail-${version}.tar.bz2";
    sha256 = "22e94f11d885cb9330a197fd80217d44f65e6b087e4d4b4d83e573adfc24aa7b";
  };

  buildInputs = [ openssl ];

  configureFlags = "--with-ssl=${openssl}";

  meta = {
    homepage = "http://www.fetchmail.info/";
    description = "a full-featured remote-mail retrieval and forwarding utility";
    longDescription = ''
      A full-featured, robust, well-documented remote-mail retrieval and
      forwarding utility intended to be used over on-demand TCP/IP links
      (such as SLIP or PPP connections). It supports every remote-mail
      protocol now in use on the Internet: POP2, POP3, RPOP, APOP, KPOP,
      all flavors of IMAP, ETRN, and ODMR. It can even support IPv6 and
      IPSEC.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
