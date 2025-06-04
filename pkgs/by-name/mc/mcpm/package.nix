{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcpm";
  version = "1.13.1"; # Last known working version without problematic dependencies

  src = fetchFromGitHub {
    owner = "pathintegral-institute";
    repo = "mcpm.sh";
    tag = "v${version}";
    hash = "sha256-vIyUaVLjfXY48ALeArs1Gdqo9tOEAkDTv+SeUL9muz0=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
    setuptools
    wheel
    pip
  ];

  dependencies = with python3Packages; [
    # Core dependencies from pyproject.toml v1.13.1
    click
    rich
    requests
    pydantic
    mcp
    ruamel-yaml
    watchfiles
    duckdb
    psutil
    prompt-toolkit
    deprecated
  ];

  meta = {
    description = "Model Context Protocol Manager";
    homepage = "https://mcpm.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "mcpm";
  };
}
