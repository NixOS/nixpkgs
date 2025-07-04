{
  lib,
  python3Packages,
  fetchFromGitHub,
  procps,
}:
python3Packages.buildPythonApplication rec {
  pname = "mackup";
  version = "0.8.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lra";
    repo = "mackup";
    rev = "${version}";
    hash = "sha256-eWSBl8BTg2FLI21DQcnepBFPF08bfm0V8lYB4mMbAiw=";
  };

  postPatch = ''
    substituteInPlace mackup/utils.py \
      --replace-fail '"/usr/bin/pgrep"' '"${lib.getExe' procps "pgrep"}"' \
  '';

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [ docopt ];

  pythonImportsCheck = [ "mackup" ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  enabledTestPaths = [ "tests/*.py" ];

  # Disabling tests failing on darwin due to a missing pgrep binary on procps
  disabledTests = [ "test_is_process_running" ];

  meta = {
    description = "Tool to keep your application settings in sync (OS X/Linux)";
    changelog = "https://github.com/lra/mackup/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/lra/mackup";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mackup";
  };
}
