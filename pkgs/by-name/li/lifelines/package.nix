{ lib, stdenv, fetchFromGitHub, fetchpatch, gettext, libiconv, bison, ncurses, perl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "lifelines";
  version = "unstable-2019-05-07";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "43f29285ed46fba322b6a14322771626e6b02c59";
    sha256 = "1agszzlmkxmznpc1xj0vzxkskrcfagfjvqsdyw1yp5yg6bsq272y";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/lifelines/lifelines/pull/437
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/lifelines/lifelines/commit/e04ce2794d458c440787c191877fbbc0784447bd.patch";
      sha256 = "1smnz4z5hfjas79bfvlnpw9x8199a5g0p9cvhf17zpcnz1432kg7";
    })
  ];

  buildInputs = [
    gettext
    libiconv
    ncurses
    perl
  ];
  nativeBuildInputs = [ autoreconfHook bison ];

  meta = with lib; {
    description = "Genealogy tool with ncurses interface";
    homepage = "https://lifelines.github.io/lifelines/";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
    platforms = platforms.linux;
  };
}
