{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "gomp";
  version = "1.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ixq9jtV56FKbh68jqmRd3lwpbMG00GcOUIpjzJhnSp0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  doCheck = false; # tests require interactive terminal

  meta = {
    description = "Tool for comparing Git branches";
    homepage = "https://github.com/MarkForged/GOMP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
    platforms = lib.platforms.unix;
    mainProgram = "gomp";
  };
}
