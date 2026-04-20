{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rpl";
  version = "1.18.1";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Fr0BMv+QMhVaHMg+Xd7pPe4/swH0dBADABKgbSIjUCo=";
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
})
