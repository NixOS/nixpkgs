{
  lib,
  stdenv,
  fetchFromGitLab,
  openssl,
  python3,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetchmail";
  version = "7.0.0-alpha11";

  src = fetchFromGitLab {
    owner = "fetchmail";
    repo = "fetchmail";
    tag = finalAttrs.version;
    hash = "sha256-83D2YlFCODK2YD+oLICdim2NtNkkJU67S3YLi8Q6ga8=";
  };

  buildInputs = [
    openssl
    python3
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];

  configureFlags = [ "--with-ssl=${openssl.dev}" ];

  postInstall = ''
    cp -a contrib/. $out/share/fetchmail-contrib
  '';

  meta = with lib; {
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
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
