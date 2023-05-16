{ lib
<<<<<<< HEAD
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.0.40";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-kZ8qVhroSPSGAcgUFZb1vRI6JoFyjeg/0qYosbRnwyc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"textx >= 3.0.0, == 3.*"' '"textx"' \
      --replace '"docutils >= 0.16, == 0.*"' '"docutils"' \
      --replace '"pygments >= 2.10.0, == 2.*"' '"pygments"' \
      --replace '"lxml >= 4.6.2, == 4.*"' '"lxml"' \
      --replace '"beautifulsoup4 >= 4.12.0, == 4.*"' '"beautifulsoup4"' \
      --replace '"python-datauri >= 0.2.9, == 0.*"' '"python-datauri"' \
      --replace '"XlsxWriter >= 1.3.7, == 1.*"' '"XlsxWriter"' \
      --replace '"xlrd >= 2.0.1, == 2.*"' '"xlrd"' \
      --replace '"reqif >= 0.0.33, == 0.*"' '"reqif"' \
      --replace '"pybtex >= 0.23.0, == 0.*"' '"pybtex"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    datauri
    docutils
    fastapi
    html5lib
    jinja2
    lxml
    markupsafe
    pybtex
    pygments
    python-multipart
    reqif
    setuptools
    textx
    toml
    uvicorn
    websockets
    xlrd
    xlsxwriter
  ] ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python3.pkgs; [
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "strictdoc"
  ];

  disabledTests = [
    # fixture 'fs' not found
    "test_001_load_from_files"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    "tests/end2end/"
  ];

  meta = with lib; {
    description = "Software requirements specification tool";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/releases/tag/${version}";
=======
  meta = with lib; {
    description = "Software requirements specification tool";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/releases";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
