{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.18";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N4043ig/ZoL4XpNpU5bzRh1xl3jheoAT9kvYfX9nHX4=";
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
