{
  lib,
  stdenv,
  fetchfossil,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "0-unstable-2026-06-03";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "641e31f18cff7215";
    hash = "sha256-AMOb1GHI99Plxdry89ynoLNpvFVpUzkdwffKLhJBKYw=";
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
