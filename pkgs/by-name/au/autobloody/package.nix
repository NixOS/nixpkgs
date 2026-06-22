{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "autobloody";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "autobloody";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iv2Al5FQMZNVrAxvrwYjglPBxEUUZ9Jn1wFd5B4b9WY=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    bloodyad
    neo4j
  ];

  # Tests require a test file which is not available in the current release
  doCheck = false;

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autobloody"
  ];

  meta = {
    description = "Tool to automatically exploit Active Directory privilege escalation paths";
    homepage = "https://github.com/CravateRouge/autobloody";
    changelog = "https://github.com/CravateRouge/autobloody/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "autobloody";
  };
})
