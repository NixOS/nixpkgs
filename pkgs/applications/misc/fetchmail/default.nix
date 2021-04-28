{ lib, stdenv, fetchurl, openssl }:

let
  version = "6.4.16";
in
stdenv.mkDerivation {
  pname = "fetchmail";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail/fetchmail-${version}.tar.xz";
    sha256 = "sha256-BEuaCsA6+653RJed7+Pi4y45FBvKaP0Mje2i7UCIT7k=";
  };

  buildInputs = [ openssl ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = {
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

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
    license = lib.licenses.gpl2Plus;
  };
}
