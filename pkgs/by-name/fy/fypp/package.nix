{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fypp";
  version = "3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aradi";
    repo = pname;
    rev = version;
    hash = "sha256-MgGVlOqOIrIVoDfBMVpFLT26mhYndxans2hfo/+jdoA=";
  };

  nativeBuildInputs = [ python3.pkgs.setuptools ];

  meta = with lib; {
    description = "Python powered Fortran preprocessor";
    mainProgram = "fypp";
    homepage = "https://github.com/aradi/fypp";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
