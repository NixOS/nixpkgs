{
  lib,
  stdenv,
  pkgs,
}:

stdenv.mkDerivation {
  pname = "fetchmail";
  version = "unstable-2022-05-26";

  src = pkgs.fetchFromGitLab {
    owner = "fetchmail";
    repo = "fetchmail";
    rev = "30b368fb8660d8fec08be1cdf2606c160b4bcb80";
    hash = "sha256-83D2YlFCODK2YD+oLICdim2NtNkkJU67S3YLi8Q6ga8=";
  };

  buildInputs = with pkgs; [
    openssl
    python3
  ];
  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
    bison
    flex
  ];

  configureFlags = [ "--with-ssl=${pkgs.openssl.dev}" ];

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
}
