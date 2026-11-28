{
  lib,
  stdenv,
  fetchfossil,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "0-unstable-2026-11-26";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "ca3b71c462649835";
    hash = "sha256-PCnsTKK0GhaKr2xUm4OTsp+nZ2E7iN0NiyWA+WpWGYg=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "CC:=$(CC)" ];

  installPhase = ''
    install -Dm755 -t $out/bin althttpd
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
    mainProgram = "althttpd";
  };
}
