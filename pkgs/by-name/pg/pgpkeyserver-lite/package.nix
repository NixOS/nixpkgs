{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "pgpkeyserver-lite";
  version = "2017-07-18";

  src = fetchFromGitHub {
    owner = "mattrude";
    repo = "pgpkeyserver-lite";
    rev = "a038cb79b927c99bf7da62f20d2c6a2f20374339";
    hash = "sha256-PQsNa+Rd4ycEVffb/q4o/dj2fbL3VlWfWGjsy65I9oo=";
  };

  installPhase = ''
    mkdir -p $out
    cp -R 404.html assets favicon.ico index.html robots.txt $out
  '';

  meta = {
    homepage = "https://github.com/mattrude/pgpkeyserver-lite";
    description = "Lightweight static front-end for a sks keyserver";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ calbrecht ];
  };
}
