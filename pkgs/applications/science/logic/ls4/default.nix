{ zlib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ls4";

  version = "unstable-2019-07-31";

  buildInputs = [ zlib ];

  preBuild = ''
  cd core
  # These object files were committed into the git repo, perhaps accidentally
  rm -f aiger.o
  rm -f aiger.o_32
  gcc -g -O3 -c aiger.c
  '';

  buildPhase = ''
  runHook preBuild
  make
  '';

  installPhase = ''
  install -D ls4 $out/bin/ls4
  '';

  src = fetchFromGitHub {
    owner = "quickbeam123";
    repo = "ls4";
    rev = "0293895817ede193277b321a38226abdfdf75bef";
    sha256 = "11j34qia9pb9jqfqggzpypi7y6bq7pdhx9pvl845n9cysc8zsdfj";
  };

  meta = with stdenv.lib; {
    description = "A solver for temporal logic, in particular a PLTL-prover based on labelled superposition with partial model guidance. Based off of minisat";
    homepage = "https://github.com/quickbeam123/ls4";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [changlinli];
  };
}
