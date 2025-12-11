{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rstfmt";
  version = "0.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dzhu";
    repo = "rstfmt";
    tag = "v${version}";
    hash = "sha256-zvmKgNzfxyWYHoaD+q84I48r1Mpp4kU4oIGAwMSRRlA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiohttp
    black
    docutils
    sphinx
  ];

  # Project has no unittest just sample files
  doCheck = false;

  pythonImportsCheck = [ "rstfmt" ];

  meta = {
    description = "Formatter for reStructuredText";
    homepage = "https://github.com/dzhu/rstfmt";
    changelog = "https://github.com/dzhu/rstfmt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rstfmt";
  };
}
