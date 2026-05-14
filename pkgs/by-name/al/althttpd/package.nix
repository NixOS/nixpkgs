{
  lib,
  stdenv,
  fetchfossil,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "0-unstable-2026-03-20";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "a8fac0faaab1f43f";
    hash = "sha256-Z4kZgCvqY7Kroc6A98s5UH4N8CEUzF+xmdXDRw2Lxtw=";
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
