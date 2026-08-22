{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ansible-doctor";
  version = "8.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1O6F7MNNdt8WX+NAqJD1ZNToB6PrfWKtoweT5Pbl9l8=";
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

  # dynaconf >= 3.3 honours fresh_vars: those keys are re-read from the
  # loaders on every get(), discarding the default written by the validator.
  # Commit 70df7a0add (the dynaconf 3.3.2 bump) dropped fresh_vars; v8.3.3
  # predates that commit, so this patch backports the change.
  patches = lib.optionals (lib.versionOlder finalAttrs.version "8.3.4") [
    (fetchpatch {
      url = "https://github.com/thegeeklab/ansible-doctor/commit/70df7a0add.patch";
      hash = "sha256-OmTKFFOgB3kaVvEowm+5/K2k/8CxLZPilQ9nmEKtEmw=";
      excludes = [
        "poetry.lock"
        "pyproject.toml"
      ];
    })
  ];

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
