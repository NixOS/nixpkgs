{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  inherit (python3Packages)
    poetry-core
    crcmod
    pycrate
    pyserial
    pyusb
    unittestCheckHook
    ;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qcsuper";
  version = "2.1.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "P1sec";
    repo = "QCSuper";
    tag = finalAttrs.version;
    hash = "sha256-fsIbtfbFRrUomgUWeFIZnMIJ7XTAa3JLvyuZabfEtb4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    crcmod
    pycrate
    pyserial
    pyusb
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "-s"
    "src/qcsuper/tests"
    "-v"
  ];

  pythonImportsCheck = [ "qcsuper" ];

  meta = {
    description = "Tool to communicate with Qualcomm-based phones and modems, allowing to capture raw 2G/3G/4G radio frames";
    homepage = "https://github.com/P1sec/QCSuper";
    changelog = "https://github.com/P1sec/QCSuper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
