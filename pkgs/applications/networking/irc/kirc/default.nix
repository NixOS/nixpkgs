{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "kirc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mcpcpc";
    repo = pname;
    rev = version;
    hash = "sha256-SXPtSFjGPLgORG9OCSCEStzNzdGZFzCx72YOrW288MU=";
  };

  dontConfigure = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "http://kirc.io/";
    description = "Tiny IRC client written in C99";
    longDescription = ''
      kirc is a tiny open-source Internet Relay Chat (IRC) client designed with
      usability and cross-platform compatibility in mind.

      It features:
      - No dependencies other than a C99 compiler.
      - Simple Authentication and Security Layer (SASL) procotol support.
      - Client-to-client (CTCP) protocol support.
      - Transport Layer Security (TLS) protocol support (via external
        utilities).
      - Simple chat history logging.
      - Asynchronous message handling.
      - Multi-channel joining at server connection.
      - Full support for all RFC 2812 commands.
      - Easy customized color scheme definition.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
