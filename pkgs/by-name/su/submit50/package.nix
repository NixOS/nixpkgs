{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "submit50";
  version = "3.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "submit50";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6DbXnu49lMz0O1Ce4CK47Y7Lorjc4SU8SuorZ40nT4=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    lib50
    packaging
    pytz
    requests
    termcolor
  ];

  pythonImportsCheck = [ "submit50" ];

  nativeCheckInputs = [ versionCheckHook ];

  # no python tests

  meta = {
    description = "Tool for submitting student CS50 code";
    homepage = "https://cs50.readthedocs.io/submit50/";
    downloadPage = "https://github.com/cs50/submit50";
    changelog = "https://github.com/cs50/submit50/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "submit50";
  };
})
