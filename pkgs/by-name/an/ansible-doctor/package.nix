{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ansible-doctor";
  version = "8.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Asp26tGyzFPOCLESXe2Je4i+0u8OGX2GSaGy/cQC3AI=";
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

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Annotation based documentation for your Ansible roles";
    mainProgram = "ansible-doctor";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    changelog = "https://github.com/thegeeklab/ansible-doctor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ tboerger ];
  };
})
