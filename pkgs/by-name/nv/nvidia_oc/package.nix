{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoAddDriverRunpath,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "nvidia_oc";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "Dreaming-Codes";
    repo = "nvidia_oc";
    tag = version;
    hash = "sha256-OYQuCNHByt9y6XGIayCw8uvZHeITqRk8PV06+pT0dhA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-94uoOzbC1ocK1LWHArUYqfaBFzOUQNSLPKnMRXXjBQ0=";

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Simple command line tool to overclock Nvidia GPUs using the NVML library on Linux";
    homepage = "https://github.com/Dreaming-Codes/nvidia_oc";
    changelog = "https://github.com/Dreaming-Codes/nvidia_oc/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "nvidia_oc";
  };
}
