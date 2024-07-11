{
  lib,
  python3Packages,
  fetchFromGitHub,
  procps,
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

  postPatch = ''
    substituteInPlace mackup/utils.py \
      --replace-fail '"/usr/bin/pgrep"' '"${lib.getExe' procps "pgrep"}"'
  '';

  nativeBuildInputs = with python3Packages; [
    poetry-core
    nose
  ];

  propagatedBuildInputs = with python3Packages; [
    six
    docopt
  ];

  pythonImportsCheck = [ "mackup" ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "A tool to keep your application settings in sync (OS X/Linux)";
    changelog = "https://github.com/lra/mackup/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/lra/mackup";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mackup";
  };
}
