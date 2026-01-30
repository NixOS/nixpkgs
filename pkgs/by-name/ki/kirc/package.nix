{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kirc";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "mcpcpc";
    repo = "kirc";
    rev = finalAttrs.version;
    hash = "sha256-ModcUryLJTbf19ZKZDQ05Wqqac5vBsCN7SaT0/TD4Ro=";
  };

  dontConfigure = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://mcpcpc.github.io/kirc/";
    description = "Tiny IRC client written in C99";
    mainProgram = "kirc";
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
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
