{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.10";
  name = "mdp-${version}";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "1swp1hqryai84c8dpzsvjpgg5rz2vnn2vrp0dhwy8r0qgpmby2nn";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer vrthra ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
