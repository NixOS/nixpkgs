{ lib
, stdenv
, fetchFromGitea
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.12.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = version;
    hash = "sha256-d4V4bI08Prmg3U0KGu4yIwpHcvTJT3NAd4lbzdBU/AE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "C99 HTML parsing algorithm";
    homepage = "https://codeberg.org/gumbo-parser/gumbo-parser";
    maintainers = [ lib.maintainers.nico202 ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.asl20;
  };
}
