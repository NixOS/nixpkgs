{
  lib,
  python3Packages,
  fetchFromGitHub,
  procps,
  fetchpatch2,
}:
python3Packages.buildPythonApplication rec {
  pname = "mackup";
  version = "0.8.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lra";
    repo = "mackup";
    rev = "refs/tags/${version}";
    hash = "sha256-hAIl9nGFRaROlt764IZg4ejw+b1dpnYpiYq4CB9dJqQ=";
  };

  patches = [
    (fetchpatch2 {
      name = "remove-six.patch";
      url = "https://github.com/lra/mackup/commit/31ae717d40360e2e9d2d46518f57dcdc95b165ca.patch";
      hash = "sha256-M2gtY03SOlPefsHREPmeajhnfmIoHbNYjm+W4YZqwKM=";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  postPatch = ''
    substituteInPlace mackup/utils.py \
      --replace-fail '"/usr/bin/pgrep"' '"${lib.getExe' procps "pgrep"}"' \
  '';

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [ docopt ];

  pythonImportsCheck = [ "mackup" ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/*.py" ];

  meta = {
    description = "A tool to keep your application settings in sync (OS X/Linux)";
    changelog = "https://github.com/lra/mackup/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/lra/mackup";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mackup";
  };
}
