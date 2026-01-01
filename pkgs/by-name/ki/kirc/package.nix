{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "kirc";
<<<<<<< HEAD
  version = "1.0.7";
=======
  version = "0.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mcpcpc";
    repo = "kirc";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ModcUryLJTbf19ZKZDQ05Wqqac5vBsCN7SaT0/TD4Ro=";
=======
    hash = "sha256-LiJZnFQMnyBEqeyyyqM56XXoYjbZPCWLfLX9OB/f+YM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontConfigure = true;

  installFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
