{ stdenv, lib, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "hexcurse-${version}";
  version = "1.58";
  src = fetchFromGitHub {
    owner = "LonnyGomes";
    repo = "hexcurse";
    rev = "hexcurse-${version}";
    sha256 = "0hm9mms2ija3wqba0mkk9i8fhb8q1pam6d6pjlingkzz6ygxnnp7";
  };
  buildInputs = [
    ncurses
  ];
  meta = with lib; {
    description = "ncurses-based console hexeditor written in C";
    homepage = "https://github.com/LonnyGomes/hexcurse";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
