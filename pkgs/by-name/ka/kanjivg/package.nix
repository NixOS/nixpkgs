{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "kanjivg";
  version = "r20260714";
  src = fetchFromGitHub {
    owner = "KanjiVG";
    repo = "kanjivg";
    rev = "d95a97627fd9fe5b2c8d06ca81e38149609c0c1e";
    hash = "sha256-gRQUu3PNFuGIhEAqNGiAcq50jZOdaHM7HQlhabubauk=";
  };

  buildPhase = ''
    mkdir -p $out
    cp kanji/* $out
  '';
}
