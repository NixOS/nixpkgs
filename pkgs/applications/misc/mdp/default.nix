{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.7";
  name = "mdp-${version}";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "10jkv8g04vvhik42y0qqcbn05hlnfsgbljhx69hx1sfn7js2d8g4";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer vrthra ];
    license = licenses.gpl3;
  };
}
