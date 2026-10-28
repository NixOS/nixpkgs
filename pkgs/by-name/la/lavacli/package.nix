{
  lib,
  fetchFromGitLab,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lavacli";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "lava";
    repo = "lavacli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-llvJGiUWeXuwia7KkeQgGBunFMNuNughYAEj7KTlIjM=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    aiohttp
    jinja2
    requests
    ruamel-yaml
    voluptuous
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pyzmq
    versionCheckHook
  ];

  meta = {
    description = "Command line tool to interact with one or many LAVA instances using XML-RPC";
    homepage = "https://lava.gitlab.io/lavacli/";
    changelog = "https://gitlab.com/lava/lavacli/-/commits/v${finalAttrs.version}?ref_type=tags";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ snu ];
    mainProgram = "lavacli";
  };
})
