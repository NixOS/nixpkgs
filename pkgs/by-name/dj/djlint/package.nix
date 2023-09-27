{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "djlint";
  version = "1.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Riverside-Healthcare";
    repo = "djLint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iorlA8Ypkzw8NuzOZT5fV3zaqHgyg6ClgQn2VO32q0k=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    colorama
    cssbeautifier
    html-tag-names
    html-void-elements
    jsbeautifier
    json5
    pathspec
    pyyaml
    regex
    tomli
    tqdm
  ];

  pythonImportsCheck = [ "djlint" ];

  meta = with lib; {
    description = "HTML Template Linter and Formatter";
    homepage = "https://djLint.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ocfox ];
    mainProgram = "djlint";
  };
})
