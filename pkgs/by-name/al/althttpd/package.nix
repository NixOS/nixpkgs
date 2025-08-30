{
  lib,
  stdenv,
  fetchfossil,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "unstable-2025-07-29";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "2ecbd4a08d95528b";
    hash = "sha256-0XU0favkp1n7dxIzEL/Wxlbi74rcZqJlGonOqZdyzHM=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "CC:=$(CC)" ];

  installPhase = ''
    install -Dm755 -t $out/bin althttpd
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
    mainProgram = "althttpd";
  };
}
