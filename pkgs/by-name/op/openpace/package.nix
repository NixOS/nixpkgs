{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  help2man,
  gengetopt,
  openssl,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "openpace";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "openpace";
    tag = version;
    hash = "sha256-KsgCTHvbqxNOcf9HWgXGxagpIjHEcQ5Kryjq71F8XRk=";
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

  preFixup = ''
    rm $out/bin/example
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cryptographic library for EAC version 2";
    homepage = "https://github.com/frankmorgner/openpace";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vaavaav ];
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform; # help2man
  };
}
