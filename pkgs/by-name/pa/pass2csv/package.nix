{
  python3Packages,
  fetchPypi,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "pass2csv";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IdcSwQ9O2HmCvT8p4tC7e2GQuhkE3kvMINszZH970og=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = [
    python3Packages.python-gnupg
  ];

  # Project has no tests.
  doCheck = false;

  meta = {
    description = "Export pass(1), \"Standard unix password manager\", to CSV";
    mainProgram = "pass2csv";
    homepage = "https://codeberg.org/svartstare/pass2csv";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
