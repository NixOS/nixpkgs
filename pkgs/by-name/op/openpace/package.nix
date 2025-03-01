{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  help2man,
  gengetopt,
  openssl,
}:
stdenv.mkDerivation rec {
  pname = "openpace";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "openpace";
    rev = version;
    sha256 = "sha256-KsgCTHvbqxNOcf9HWgXGxagpIjHEcQ5Kryjq71F8XRk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    help2man
    gengetopt
  ];

  buildInputs = [ openssl ];

  preConfigure = ''
    autoreconf --verbose --install
  '';

  meta = with lib; {
    description = "Cryptographic library for EAC version 2";
    homepage = "https://github.com/frankmorgner/openpace";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vaavaav ];
  };
}
