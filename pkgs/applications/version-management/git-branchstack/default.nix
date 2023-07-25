{ lib
, fetchPypi
, buildPythonApplication
, git-revise
}:

buildPythonApplication rec {
  pname = "git-branchstack";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gja93LOcVCQ6l+Cygvsm+3uomvxtvUl6t23GIb/tKyQ=";
  };

  buildInputs = [
    git-revise
  ];

  meta = with lib; {
    homepage = "https://github.com/krobelus/git-branchstack";
    description = "Efficiently manage Git branches without leaving your local branch";
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
