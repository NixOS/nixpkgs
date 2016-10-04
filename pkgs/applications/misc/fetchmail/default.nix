{ stdenv, fetchurl, openssl }:

let
  version = "6.3.26";
in
stdenv.mkDerivation {
  name="fetchmail-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail.berlios/fetchmail-${version}.tar.bz2";
    sha256 = "08rafrs1dlr11myr0p99kg4k80qyy0fa63gg3ac88zn49174lwhw";
  };

  buildInputs = [ openssl ];

  configureFlags = "--with-ssl=${openssl.dev}";

  meta = {
    homepage = "http://www.fetchmail.info/";
    description = "A full-featured remote-mail retrieval and forwarding utility";
    longDescription = ''
      A full-featured, robust, well-documented remote-mail retrieval and
      forwarding utility intended to be used over on-demand TCP/IP links
      (such as SLIP or PPP connections). It supports every remote-mail
      protocol now in use on the Internet: POP2, POP3, RPOP, APOP, KPOP,
      all flavors of IMAP, ETRN, and ODMR. It can even support IPv6 and
      IPSEC.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
