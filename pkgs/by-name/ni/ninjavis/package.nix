{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "ninjavis";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chagui";
    repo = "ninjavis";
    tag = "v${version}";
    hash = "sha256-4MXU43noG0mKwiXWrLu1tW9YGkU1YjP/UoUKZzVer14=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  pythonImportsCheck = [
    "ninjavis"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    env --ignore-environment $out/bin/ninjavis --help

    runHook postInstallCheck
  '';

  meta = {
    description = "Generate visualization from Ninja build logs";
    homepage = "https://github.com/chagui/ninjavis";
    changelog = "https://github.com/chagui/ninjavis/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "ninjavis";
  };
}
