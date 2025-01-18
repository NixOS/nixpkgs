{
  lib,
  fetchPypi,
  python3Packages,
}:

let
  self = python3Packages.buildPythonApplication {
    pname = "git-branchstack";
    version = "0.2.0";

    src = fetchPypi {
      pname = "git-branchstack";
      inherit (self) version;
      hash = "sha256-gja93LOcVCQ6l+Cygvsm+3uomvxtvUl6t23GIb/tKyQ=";
    };

    dependencies = with python3Packages; [
      git-revise
    ];

    meta = with lib; {
      homepage = "https://github.com/krobelus/git-branchstack";
      description = "Efficiently manage Git branches without leaving your local branch";
      license = licenses.mit;
      maintainers = with maintainers; [ AndersonTorres ];
    };
  };
in
self
