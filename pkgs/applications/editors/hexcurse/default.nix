{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "hexcurse-${version}";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "LonnyGomes";
    repo = "hexcurse";
    rev = "v${version}";
    sha256 = "17ckkxfzbqvvfdnh10if4aqdcq98q3vl6dn1v6f4lhr4ifnyjdlk";
  };
  buildInputs = [ ncurses ];
  
  meta = with lib; {
    description = "ncurses-based console hexeditor written in C";
    homepage = https://github.com/LonnyGomes/hexcurse;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
