{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  version = "3.3-unstable-2023-05-08";
  pname = "httptunnel";

  src = fetchFromGitHub {
    owner = "larsbrinkhoff";
    repo = "httptunnel";
    rev = "d8f91af976c97a6006a5bd1ad7149380c39ba454";
    hash = "sha256-fUaVHE3nxq3fU7DYCvaQTOoMzax/qFH8cMegFLLybNk=";
  };

  # httptunnel makes liberal use of old C features, just selecting an old version
  # is easier than patching around language updates.
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Creates a bidirectional virtual data connection tunnelled in HTTP requests";
    homepage = "http://www.gnu.org/software/httptunnel/httptunnel.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ koral ];
    platforms = lib.platforms.unix;
  };
}
