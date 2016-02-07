{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.4";
  name = "mdp-${version}";

  src = fetchurl {
    url = "https://github.com/visit1985/mdp/archive/${version}.tar.gz";
    sha256 = "1wvys3sb0ki7zz5b0y4bl9x6jdj7h88lxsf8vap95k1sj2ymanlm";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3;
  };
}
