{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = version;
    hash = "sha256-6kHeILapewfyJjp5Xtq0rK5eHf8jymvc5xFGW8Qi9VU=";
  };

  cargoHash = "sha256-evxwaZkToAjVvrnvOmz3HpOi+976sxPCOIlR8rmpYyo=";

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
