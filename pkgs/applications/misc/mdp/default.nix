{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "mdp-${version}";

  src = fetchurl {
    url = "https://github.com/visit1985/mdp/archive/${version}.tar.gz";
    sha256 = "0vmr0ymq06r50yags9nv6fk4f890b82a7bvxg697vrgs04i2x4dy";
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
