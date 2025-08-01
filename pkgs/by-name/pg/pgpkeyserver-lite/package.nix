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
    sha256 = "12pn92pcpv38b2gmamppn9yzdn7x52pgxnzpal22gqsxwimhs2rx";
  };

  installPhase = ''
    mkdir -p $out
    cp -R 404.html assets favicon.ico index.html robots.txt $out
  '';

  meta = with lib; {
    homepage = "https://github.com/mattrude/pgpkeyserver-lite";
    description = "Lightweight static front-end for a sks keyserver";
    license = licenses.gpl3;
    maintainers = with maintainers; [ calbrecht ];
  };
}
