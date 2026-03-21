{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "kubectl-view-allocations";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = version;
    hash = "sha256-AZsieePjIFY3xXG39tfwSvRcNgLdvEQSKALXgRCkuc4=";
  };

  cargoHash = "sha256-0bStmuLFkYsyd7rJlHA7/rXGtlh2CvjXWPnDwoq33v4=";

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
