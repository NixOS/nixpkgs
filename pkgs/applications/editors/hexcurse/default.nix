{ stdenv, lib, fetchFromGitHub, fetchpatch, ncurses }:

stdenv.mkDerivation rec {
  pname = "hexcurse";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "LonnyGomes";
    repo = "hexcurse";
    rev = "v${version}";
    sha256 = "17ckkxfzbqvvfdnh10if4aqdcq98q3vl6dn1v6f4lhr4ifnyjdlk";
  };
  buildInputs = [ ncurses ];
  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-overflow" "-Wno-error=stringop-truncation" ];
  patches = [
    # gcc7 compat
    (fetchpatch {
      url = https://github.com/LonnyGomes/hexcurse/commit/d808cb7067d1df067f8b707fabbfaf9f8931484c.patch;
      sha256 = "0h8345blmc401c6bivf0imn4cwii67264yrzxg821r46wrnfvyi2";
    })
    # gcc7 compat
    (fetchpatch {
      url = https://github.com/LonnyGomes/hexcurse/commit/716b5d58ac859cc240b8ccb9cbd79ace3e0593c1.patch;
      sha256 = "0v6gbp6pjpmnzswlf6d97aywiy015g3kcmfrrkspsbb7lh1y3nix";
    })
  ];

  meta = with lib; {
    description = "ncurses-based console hexeditor written in C";
    homepage = https://github.com/LonnyGomes/hexcurse;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
