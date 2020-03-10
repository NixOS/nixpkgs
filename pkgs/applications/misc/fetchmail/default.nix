{ stdenv, fetchurl, openssl }:

let
  version = "6.4.2";
in
stdenv.mkDerivation {
  pname = "fetchmail";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/fetchmail/fetchmail-${version}.tar.xz";
    sha256 = "0c563if3kribnj771l14aj06irmrlhm61dc68w6dp7zj4qrnn7z2";
  };

  buildInputs = [ openssl ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  meta = {
    homepage = http://www.fetchmail.info/;
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
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
