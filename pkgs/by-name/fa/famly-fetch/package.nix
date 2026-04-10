{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "famly-fetch";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacobbunk";
    repo = "famly-fetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uyLGBNV+GiYNqy4wWxPNx/xQL0lnMsIHfPIlaIu85HA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    importlib-resources
    piexif
  ];

  pythonImportsCheck = [ "famly_fetch" ];

  # No tests in the repository
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Fetch your (kid's) images from famly.co";
    homepage = "https://github.com/jacobbunk/famly-fetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tlvince ];
    mainProgram = "famly-fetch";
  };
})
