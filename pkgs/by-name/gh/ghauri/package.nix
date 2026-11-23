{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ghauri";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "r0oth3x49";
    repo = "ghauri";
    tag = finalAttrs.version;
    hash = "sha256-sZooW50kvgz52xAy1xCdzL+6g4Az914ZcFfdxZllTts=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    chardet
    colorama
    requests
    tldextract
    ua-generator
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghauri"
  ];

  meta = {
    description = "Tool for detecting and exploiting SQL injection security flaws";
    homepage = "https://github.com/r0oth3x49/ghauri";
    changelog = "https://github.com/r0oth3x49/ghauri/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ghauri";
  };
})
