{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "grasp-backend";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karlicoss";
    repo = "grasp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4eHY58ulvLGkKHfEishRlWPI52juxWP2zzUDwRmTM/k=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "grasp_backend" ];

  # Tests do not seem possible to run with pytest:
  # RuntimeError: ("Couldn't determine path for ", PosixPath('/build/source/tests/webdriver_utils.py'))
  doCheck = false;

  meta = {
    description = "Backend for grasp browser extension";
    mainProgram = "grasp_backend";
    maintainers = with lib.maintainers; [ hiro98 ];
    homepage = "https://github.com/karlicoss/grasp/";
    changelog = "https://github.com/karlicoss/grasp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
