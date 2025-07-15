{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "ansible-doctor";
  version = "7.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    tag = "v${version}";
    hash = "sha256-BwmmAd1mmyGQ5QQo6uS3+JmPP9kmZe2OOBDNAKFqEl0=";
  };

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    anyconfig
    appdirs
    colorama
    dynaconf
    environs
    gitpython
    jinja2
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    ruamel-yaml
    structlog
  ];

  pythonRelaxDeps = true;

  doCheck = true;

  pythonImportsCheck = [ "ansibledoctor" ];

  # ansible.errors.AnsibleError: Unable to create local directories(/private/var/empty/.ansible/tmp)
  nativeCheckInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Annotation based documentation for your Ansible roles";
    mainProgram = "ansible-doctor";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    changelog = "https://github.com/thegeeklab/ansible-doctor/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ tboerger ];
  };
}
