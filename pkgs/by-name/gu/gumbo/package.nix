{ lib
, stdenv
, fetchFromGitea
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.12.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = version;
    hash = "sha256-Ug2Qib1T/SOWXLcv7t9kZ2m0PTwzctg/68U2ooeR+tk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "C99 HTML parsing algorithm";
    homepage = "https://codeberg.org/gumbo-parser/gumbo-parser";
    maintainers = [ maintainers.nico202 ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
  };
}
