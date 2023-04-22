{ lib
, stdenv
, buildPythonApplication
, fetchFromGitHub
, python3
, html5lib
, invoke
, openpyxl
, poetry-core
, tidylib
, beautifulsoup4
, datauri
, docutils
, jinja2
, lxml
, markupsafe
, pygments
, reqif
, setuptools
, textx
, xlrd
, xlsxwriter
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.0.26";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
    rev = version;
    sha256 = "sha256-SMAwji75AjW8CzXRKBDF+fR/a5++GhgIvkcuD+a/vp4=";
  };

  patches = [
    ./conftest.py.patch
  ];

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py \
      --replace @strictdoc_root_path@ "${placeholder "out"}/${python3.sitePackages}/strictdoc"

    substituteInPlace requirements.txt \
      --replace "jinja2 >= 2.11.2, <3.0" "jinja2 >= 2.11.2" \
      --replace "reqif >= 0.0.18, == 0.*" "reqif>=0.0.8" \
      --replace "==" ">=" \
      --replace "~=" ">="
  '';

  nativeBuildInputs = [
    html5lib
    invoke
    openpyxl
    poetry-core
    tidylib
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    datauri
    docutils
    jinja2
    lxml
    markupsafe
    pygments
    reqif
    setuptools
    textx
    xlrd
    xlsxwriter
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "strictdoc"
  ];

  disabledTests = [
    # fixture 'fs' not found
    "test_001_load_from_files"
  ];

  meta = with lib; {
    description = "Software requirements specification tool";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
