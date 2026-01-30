{
  lib,
  fetchFromGitLab,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lavacli";
  version = "2.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "lava";
    repo = "lavacli";
    tag = "v${version}";
    hash = "sha256-UiAqZJU7+x8f53myMY0gUwQ5PYNzKmO6kYWEqs1QvG4=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    jinja2
    requests
    ruamel-yaml
    voluptuous
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pyzmq
  ];

  meta = {
    description = "Command line tool to interact with one or many LAVA instances using XML-RPC";
    homepage = "https://lava.gitlab.io/lavacli/";
    changelog = "https://gitlab.com/lava/lavacli/-/commits/v${version}?ref_type=tags";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ snu ];
    mainProgram = "lavacli";
  };
}
