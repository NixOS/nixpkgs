{
  lib,
  stdenv,
  fetchfossil,
  openssl,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "0-unstable-2023-08-12";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "c0bdc68e6c56ef25";
    hash = "sha256-VoDR5MlVlvar9wYA0kUhvDQVjxDwsZlqrNR3u4Tqw5c=";
  };

  buildInputs = [ openssl ];

  makeFlags = [ "CC:=$(CC)" ];

  installPhase = ''
    install -Dm755 -t $out/bin althttpd
  '';

  meta = {
    description = "Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
    mainProgram = "althttpd";
  };
}
