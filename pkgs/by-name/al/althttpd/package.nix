{
  lib,
  stdenv,
  fetchfossil,
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "althttpd";
  version = "unstable-2025-08-22";

  src = fetchfossil {
    url = "https://sqlite.org/althttpd/";
    rev = "e9bf26f78e1f5792";
    hash = "sha256-Q16tqhnPzYrFkrHTC8NBrdpsbrpjPUkdxLwmyYqUHZo=";
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
