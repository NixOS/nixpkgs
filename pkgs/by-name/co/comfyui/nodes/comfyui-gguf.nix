{
  lib,
  fetchFromGitHub,
  mkComfyuiNode,
  python3Packages,
}:

mkComfyuiNode rec {
  pname = "comfyui-gguf";
  version = "2.0.0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "city96";
    repo = "ComfyUI-GGUF";
    rev = "6ea2651e7df66d7585f6ffee804b20e92fb38b8a";
    hash = "sha256-/ZwecgxTTMo9J1whdEJci8lEkOy/yP+UmjbpOAA3BvU=";
  };

  banditSkipChecks = [
    # LOW - some basic asserts for object types
    "B101"
    # LOW - try_except_continue
    "B112"
    # LOW - hardcoded_password_string - several false positives
    "B105"
  ];

  propagatedBuildInputs = [
    python3Packages.gguf
  ];

  meta = {
    description = "GGUF Quantization support for native ComfyUI models";
    homepage = "https://github.com/city96/ComfyUI-GGUF/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}

# {
#   lib,
#   buildPythonPackage,
#   fetchFromGitHub,

#   setuptools,

#   unittestCheckHook,
# }:

# buildPythonPackage rec {
#   pname = "comfyui-gguf";
#   version = "2.0.0-unstable-2025-09-14";
#   pyproject = true;

#   src = fetchFromGitHub {
#     owner = "city96";
#     repo = "ComfyUI-GGUF";
#     rev = "be2a08330d7ec232d684e50ab938870d7529471e";
#     hash = "sha256-NtpoLwlcMXeVCffZmQeHKDl9hM6gCBprdnhHblrWQ20=";
#   };
#   build-system = [ setuptools ];

#   pythonImportsCheck = [ "comfyui_gguf" ];

#   meta = {
#     description = "Embedded documentation for ComfyUI nodes";
#     homepage = "https://github.com/Comfy-Org/embedded-docs/";
#     license = lib.licenses.gpl3Only;
#     maintainers = with lib.maintainers; [
#       jk
#     ];
#   };
# }
