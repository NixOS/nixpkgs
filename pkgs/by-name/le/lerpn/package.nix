{
  python3,
  lib,
  fetchFromGitea,
}:

python3.pkgs.buildPythonApplication {
  pname = "lerpn";
  version = "unstable-2023-06-09";

  src = fetchFromGitea {
    domain = "gitea.alexisvl.rocks";
    owner = "alexisvl";
    repo = "lerpn";
    rev = "b65e56cfbbb38f8200e7b0c18b3a585ae768c6e2";
    hash = "sha256-4xqBHcOWHAvQtXS9CJWTGTdE4SGHxjghZY+/KPUgX70=";
  };

  checkPhase = ''
    runHook preCheck
    patchShebangs test

    substituteInPlace test --replace "#raise TestFailedException()" "sys.exit(1)"
    ./test
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://gitea.alexisvl.rocks/alexisvl/lerpn";
    description = "Curses RPN calculator written in straight Python";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    mainProgram = "lerpn";
  };
}
