{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.20.5";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = version;
    hash = "sha256-Y+Yki0wTi/OTWbUvk+8EhTlhF7H51RrdFLFXk2VqF1M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6sRpsXydzKB0ZaV1HeagINgb6ol9dj3XT0+pd53QOCw=";

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
