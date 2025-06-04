{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = version;
    hash = "sha256-WIByZc2B38NC+kp0ODQjYS81R7vX60A2aoVaE86w/NQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aSI5SN0RujHVq7VNNsV6m3KnQqVTWyqfLmGHhwH/3ig=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mrene ];
    platforms = lib.platforms.unix;
  };
}
