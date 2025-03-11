{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "3.3-unstable-2023-05-08";
  pname = "httptunnel";

  src = fetchFromGitHub {
    owner = "larsbrinkhoff";
    repo = "httptunnel";
    rev = "d8f91af976c97a6006a5bd1ad7149380c39ba454";
    hash = "sha256-fUaVHE3nxq3fU7DYCvaQTOoMzax/qFH8cMegFLLybNk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Creates a bidirectional virtual data connection tunnelled in HTTP requests";
    homepage = "http://www.gnu.org/software/httptunnel/httptunnel.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.unix;
  };
}
