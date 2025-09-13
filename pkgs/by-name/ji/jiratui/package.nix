{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "jiratui";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whyisdifficult";
    repo = "jiratui";
    tag = "v${version}";
    hash = "sha256-9X2VEEQHCujod7nIS0tazAwDTozWYHTflUJ9wvgmv5U=";
  };

  build-system = [
    python3Packages.uv-build
  ];

  dependencies = builtins.attrValues {
    inherit (python3Packages)
      click
      httpx
      pydantic-settings
      python-json-logger
      textual
      tonalite
      ;
  };

  pythonRemoveDeps = [
    # Shouldn't be in the package dependencies
    "pre-commit"
  ];

  pythonRelaxDeps = [
    # click>=8.2.1 not satisfied by version 8.1.8
    "click"
  ];

  meta = {
    description = "Textual User Interface for interacting with Atlassian Jira from your shell";
    homepage = "https://github.com/whyisdifficult/jiratui";
    license = lib.licenses.mit;
    mainProgram = "jiratui";
    maintainers = [ lib.maintainers.gekoke ];
  };
}
