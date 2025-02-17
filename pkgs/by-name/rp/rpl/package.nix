{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.16.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VTm4KU59Yk501tUdVn4z3bFx9Ot00CDL9HGlf44/t44=";
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

  meta = with lib; {
    description = "Replace strings in files";
    mainProgram = "rpl";
    homepage = "https://github.com/rrthomas/rpl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ cbley ];
  };
}
