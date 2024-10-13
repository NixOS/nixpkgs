{ lib
, fetchPypi
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "git-branchstack";
  version = "0.2.0";

  src = fetchPypi {
    pname = "git-branchstack";
    inherit version;
    hash = "sha256-gja93LOcVCQ6l+Cygvsm+3uomvxtvUl6t23GIb/tKyQ=";
  };

  buildInputs = with python3Packages; [
    git-revise
  ];

  meta = with lib; {
    homepage = "https://github.com/krobelus/git-branchstack";
    description = "Efficiently manage Git branches without leaving your local branch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
