{ stdenv, fetchurl, ocamlPackages, ncurses, gsl }:

stdenv.mkDerivation rec {
  name = "orpie-${version}";
  version = "1.5.2";

  src = fetchurl {
    url = "http://pessimization.com/software/orpie/${name}.tar.gz";
    sha256 = "0v9xgpcf186ni55rkmx008msyszw0ypd6rd98hgwpih8yv3pymfy";
  };

  buildInputs = [ ncurses gsl ] ++ (with ocamlPackages; [ ocaml camlp4 ]);

  meta = {
    homepage = https://github.com/pelzlpj/orpie;
    description = "A fullscreen RPN calculator for the console";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ obadz ];
  };
}
