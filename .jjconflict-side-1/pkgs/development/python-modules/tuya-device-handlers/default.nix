{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  tuya-device-sharing-sdk,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "tuya-device-handlers";
  version = "0.0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "tuya-device-handlers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O5rRzUrNEQvaX4BK+n8V8/tWXHwmf0ZiJ9LEBOFY5eo=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ poetry-core ];

  dependencies = [ tuya-device-sharing-sdk ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # pathlib.Path(path).relative_to(_PROJECT_ROOT) evaluates to a path that is not below the build dir
    "test_customer_device_with_quirk_as_dict"
  ];

  pythonImportsCheck = [ "tuya_device_handlers" ];

  meta = {
    description = "Tuya quirks library";
    homepage = "https://github.com/home-assistant-libs/tuya-device-handlers";
    changelog = "https://github.com/home-assistant-libs/tuya-device-handlers/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
