{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "jiratui";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whyisdifficult";
    repo = "jiratui";
    tag = "v${version}";
    hash = "sha256-fzbZ0UIGDRM/NJtkojAVNvIATIzpPz7vQu+BmqFqVVM=";
  };

  build-system = [
    python3Packages.uv-build
  ];

  dependencies = builtins.attrValues {
    inherit (python3Packages)
      click
      httpx
      pydantic-settings
      python-dateutil
      python-json-logger
      textual
      xdg-base-dirs
      ;
    inherit (python3Packages.pydantic-settings.optional-dependencies) yaml;
    inherit (python3Packages.textual.optional-dependencies) syntax;
  };

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
