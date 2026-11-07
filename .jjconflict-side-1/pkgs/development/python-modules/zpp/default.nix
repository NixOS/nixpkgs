{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  versionCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "zpp";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbigot";
    repo = "zpp";
    tag = finalAttrs.version;
    hash = "sha256-P1wrhyFU6VMlmvxOITrPd3F3dnd1tY53gt4SBo7UNiA=";
  };

  postPatch = ''
    substituteInPlace zpp/version.py \
      --replace-fail "1.1.0" "1.1.1"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "'Z' pre-processor, the last preprocessor you'll ever need";
    homepage = "https://github.com/jbigot/zpp";
    license = lib.licenses.mit;
    mainProgram = "zpp";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
