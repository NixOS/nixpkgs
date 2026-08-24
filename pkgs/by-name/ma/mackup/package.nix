{
  fetchFromGitHub,
  lib,
  procps,
  python3Packages,
  stdenv,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mackup";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lra";
    repo = "mackup";
    rev = "${finalAttrs.version}";
    hash = "sha256-qr/+Ot2mGRn/uZ2h6mOoNKS0Oeik0mBgpV2Kt3Lc6yg=";
  };

  postPatch = ''
    substituteInPlace src/mackup/utils.py \
      --replace-fail '"/usr/bin/pgrep"' '"${lib.getExe' procps "pgrep"}"'
  '';

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [ docopt-ng ];

  pythonImportsCheck = [ "mackup" ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  enabledTestPaths = [ "tests/*.py" ];

  # Disabling tests failing on darwin due to a missing pgrep binary on procps
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_is_process_running" ];

  meta = {
    description = "Tool to keep your application settings in sync (OS X/Linux)";
    changelog = "https://github.com/lra/mackup/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/lra/mackup";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mackup";
  };
})
