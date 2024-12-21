{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "gomp";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ixq9jtV56FKbh68jqmRd3lwpbMG00GcOUIpjzJhnSp0=";
  };

  doCheck = false; # tests require interactive terminal

  meta = with lib; {
    description = "Tool for comparing Git branches";
    homepage = "https://github.com/MarkForged/GOMP";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.unix;
    mainProgram = "gomp";
  };
}
