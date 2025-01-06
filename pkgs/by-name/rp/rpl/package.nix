{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.15.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xq3GLa1TnS4nobPHHCkFUEo9vgI4DGyY2/hQWtkwNRA=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pytest-datafiles
    python3Packages.pytestCheckHook
  ];

  propagatedBuildInputs = [
    python3Packages.argparse-manpage
    python3Packages.chainstream
    python3Packages.chardet
    python3Packages.regex
  ];

  meta = {
    description = "Replace strings in files";
    mainProgram = "rpl";
    homepage = "https://github.com/rrthomas/rpl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ cbley ];
  };
}
