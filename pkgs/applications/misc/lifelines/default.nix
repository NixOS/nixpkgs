{ stdenv, fetchFromGitHub, gettext, libiconv, bison, ncurses, perl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "lifelines";
  version = "unstable-2019-05-07";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "43f29285ed46fba322b6a14322771626e6b02c59";
    sha256 = "1agszzlmkxmznpc1xj0vzxkskrcfagfjvqsdyw1yp5yg6bsq272y";
  };

  buildInputs = [
    gettext
    libiconv
    ncurses
    perl
  ];
  nativeBuildInputs = [ autoreconfHook bison ];

  meta = with stdenv.lib; {
    description = "Genealogy tool with ncurses interface";
    homepage = "https://lifelines.github.io/lifelines/";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
    platforms = platforms.linux;
  };
}
