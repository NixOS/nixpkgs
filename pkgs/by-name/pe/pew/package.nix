{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pew";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04anak82p4v9w0lgfs55s7diywxil6amq8c8bhli143ca8l2fcdq";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    virtualenv
    virtualenv-clone
    setuptools # pkg_resources is imported during runtime
  ];

  # no tests are packaged
  checkPhase = ''
    $out/bin/pew > /dev/null
  '';

  pythonImportsCheck = [ "pew" ];

  meta = with lib; {
    homepage = "https://github.com/berdario/pew";
    description = "Tools to manage multiple virtualenvs written in pure python";
    mainProgram = "pew";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ berdario ];
  };
}
