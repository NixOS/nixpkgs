{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  expat,
  libmicrohttpd,
}:
stdenv.mkDerivation {
  pname = "stabber-unstable";
  version = "2026-03-05";

  src = fetchFromGitHub {
    owner = "profanity-im";
    repo = "stabber";
    rev = "ba6ca0707833c70ab38681bcc28bfff025c491f1";
    hash = "sha256-q3WfPjqD4AotdDukVMNg9Hz/Ns2PgBaoNk06sFm0E68=";
  };

  preAutoreconf = ''
    mkdir m4
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    glib
    expat
    libmicrohttpd
  ];

  meta = {
    description = "Stubbed XMPP Server";
    mainProgram = "stabber";
    homepage = "https://github.com/profanity-im/stabber";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ hschaeidt ];
  };
}
