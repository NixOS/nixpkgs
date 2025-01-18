{
  lib,
  stdenv,
  fetchfossil,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "althttpd";
  version = "unstable-2023-08-12";

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

  meta = with lib; {
    description = "Althttpd webserver";
    homepage = "https://sqlite.org/althttpd/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
    mainProgram = "althttpd";
  };
}
