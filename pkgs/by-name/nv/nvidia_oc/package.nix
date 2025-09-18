{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoAddDriverRunpath,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "nvidia_oc";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "Dreaming-Codes";
    repo = "nvidia_oc";
    tag = version;
    hash = "sha256-I5L+VUcbMw4lLvEvtcjs/3BXLKovEg/34DZAL4a7LJU=";
  };

  cargoHash = "sha256-VRrMSDKB8VrfdKUbZ63XY1oq0xaxgcwn739dt0C/KKY=";

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Simple command line tool to overclock Nvidia GPUs using the NVML library on Linux";
    homepage = "https://github.com/Dreaming-Codes/nvidia_oc";
    changelog = "https://github.com/Dreaming-Codes/nvidia_oc/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "nvidia_oc";
  };
}
