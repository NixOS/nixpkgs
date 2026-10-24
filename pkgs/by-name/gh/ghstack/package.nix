{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ghstack";
  version = "0.13.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "ghstack";
    tag = finalAttrs.version;
    hash = "sha256-cRdwX5BVdpGjLPR0tpFYo62HYu/lmUzJE+vyxI9A4O8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.6,<0.7"]' 'requires = ["uv_build>=0.6"]'
  '';

  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [
    aiohttp
    click
    flake8
    importlib-metadata
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "ghstack.cli" ];

  # pytests require sqlite db access

  versionCheckKeepEnvironment = [ "HOME" ];
  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Submit stacked diffs to GitHub on the command line";
    homepage = "https://github.com/ezyang/ghstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      munksgaard
      shikanime
    ];
    mainProgram = "ghstack";
  };
})
