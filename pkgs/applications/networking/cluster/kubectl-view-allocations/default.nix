{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = version;
    hash = "sha256-sqc6BnJCekZwW7A3YGN9OhbJsR1ZTrtRhBiGN+F2ac0=";
  };

  cargoHash = "sha256-7sGw3gK330QsbWEHEkJhegv9TF1tbQyJqPYdYe1PQ7k=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mrene ];
    platforms = lib.platforms.unix;
  };
}
