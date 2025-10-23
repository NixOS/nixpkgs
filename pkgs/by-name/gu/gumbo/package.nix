{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "gumbo";
  version = "0.13.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gumbo-parser";
    repo = "gumbo-parser";
    rev = version;
    hash = "sha256-8mri7mLZkuIZgzE6p0yc41bNNyzGTV9V90OiA/9TkkU=";
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
