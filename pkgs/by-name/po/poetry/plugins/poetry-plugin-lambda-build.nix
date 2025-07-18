{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docker,
  poetry-core,
  pytest-cov,
  pytestCheckHook,
  poetry,
  pip,
}:

buildPythonPackage rec {
  pname = "poetry-plugin-lambda-build";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "micmurawski";
    repo = "poetry-plugin-lambda-build";
    tag = version;
    hash = "sha256-i9vFLiuEXTsNhdvSPQQUh2EYwSjlmgRepplf24eddeA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    docker
  ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
    poetry
    pip
  ];

  preCheck = ''
    export POETRY_CACHE_DIR=$TMPDIR/.cache/pypoetry
    export POETRY_VIRTUALENVS_PATH=$TMPDIR/.cache/pypoetry/virtualenvs
  '';

  # it's kinda stupid to include this here, but maybe upstream would be open to
  # including it.
  postPatch = ''
    substituteInPlace tests/test_builds.py \
      --replace 'if platform.system() == "Darwin":' \
                'if platform.system() == "Darwin" and "USER" in os.environ:'
  '';

  # I don't know how do get this escaping/quoting stuff to work right with the
  # newer `pytestFlags` attribute, but this works with pytestFlagsArray:
  pytestFlagsArray = [
    "-k 'not container and not docker'"
  ];

  meta = {
    description = "Poetry plugin for building packages for serverless functions deployments";
    license = lib.licenses.mit;
    homepage = "https://github.com/micmurawski/poetry-plugin-lambda-build/";
    maintainers = with lib.maintainers; [ pacaroha ];
  };
}
