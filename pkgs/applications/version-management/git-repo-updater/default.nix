{ lib
, buildPythonApplication
, colorama
, fetchPypi
, gitpython
}:

buildPythonApplication rec {
  pname = "gitup";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T3hwec1l2PYMWEIYEgRjXhty01M66R8MYZYkxrIIRt0=";
  };

  propagatedBuildInputs = [
    colorama
    gitpython
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Easily update multiple Git repositories at once";
    homepage = "https://github.com/earwig/git-repo-updater";
    license = licenses.mit;
    maintainers = with maintainers; [bdesham ];
    mainProgram = "gitup";
  };
}
