{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bashate";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "bashate";
    tag = finalAttrs.version;
    hash = "sha256-e38KiGjdj7iY+7YuCyApxem2GAKHRNVFzO04QJOFC/Q=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    babel
    pbr
  ];

  nativeCheckInputs = with python3Packages; [
    fixtures
    mock
    stestrCheckHook
    testtools
  ];

  pythonImportsCheck = [ "bashate" ];

  meta = {
    description = "Style enforcement for bash programs";
    mainProgram = "bashate";
    homepage = "https://opendev.org/openstack/bashate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    teams = [ lib.teams.openstack ];
  };
})
