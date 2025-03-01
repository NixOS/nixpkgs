{ lib
, stdenv
, fetchFromGitea
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.13.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = version;
    hash = "sha256-QpGOBKNPBryCXZKKEQMv9TXJiNyXESBFiR4wM0lmjiI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C99 HTML parsing algorithm";
    homepage = "https://codeberg.org/gumbo-parser/gumbo-parser";
    maintainers = [ maintainers.nico202 ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
  };
}
