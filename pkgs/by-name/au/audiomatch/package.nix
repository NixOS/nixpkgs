{
  lib,
  chromaprint,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  version = "0.2.2";
  pname = "audiomatch";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "unmade";
    repo = "audiomatch";
    tag = version;
    hash = "sha256-I7gTP2lwg4EDNmI+tVmI721/nEDShb7q21tD9tRbskY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
     --replace-fail 'poetry>=0.12,<1.0' "poetry-core" \
     --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'

    substituteInPlace src/audiomatch/fingerprints.py \
     --replace-fail 'fpcalc' '${lib.getExe chromaprint}'
  '';

  build-system = [
    python3Packages.poetry-core
    python3Packages.distutils
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/unmade/audiomatch";
    description = "A small command-line tool to find similar audio files";
    changelog = "https://github.com/unmade/audiomatch/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "audiomatch";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
}
