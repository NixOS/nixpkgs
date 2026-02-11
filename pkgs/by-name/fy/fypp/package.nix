{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fypp";
  version = "3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aradi";
    repo = "fypp";
    rev = finalAttrs.version;
    hash = "sha256-MgGVlOqOIrIVoDfBMVpFLT26mhYndxans2hfo/+jdoA=";
  };

  nativeBuildInputs = [ python3.pkgs.setuptools ];

  meta = {
    description = "Python powered Fortran preprocessor";
    mainProgram = "fypp";
    homepage = "https://github.com/aradi/fypp";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
