{
  fetchFromGitHub,
  lib,
  procps,
  python3Packages,
  stdenv,
}:
python3Packages.buildPythonApplication rec {
  pname = "mackup";
<<<<<<< HEAD
  version = "0.10.1";
=======
  version = "0.9.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lra";
    repo = "mackup";
    rev = "${version}";
<<<<<<< HEAD
    hash = "sha256-tFuIpR8EsTbiuHCb5RS9QPQ3YpnvYOWOBEOI5J9jaSM=";
  };

  postPatch = ''
    substituteInPlace src/mackup/utils.py \
=======
    hash = "sha256-10Q0lb2wiDjD4v2yFBvG3tvy9r+/T/ni4QhHUPyxFO0=";
  };

  postPatch = ''
    substituteInPlace mackup/utils.py \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      --replace-fail '"/usr/bin/pgrep"' '"${lib.getExe' procps "pgrep"}"' \
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
    changelog = "https://github.com/lra/mackup/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/lra/mackup";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mackup";
  };
}
