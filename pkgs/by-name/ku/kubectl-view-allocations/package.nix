{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubectl-view-allocations";
  version = "3.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "davidB";
    repo = "kubectl-view-allocations";
    tag = finalAttrs.version;
    hash = "sha256-D1fLIFHXljGt1q8Q9Drfh+XhTfoWevG0v+RXBS4spP4=";
  };

  cargoHash = "sha256-hPZhXWLK5R/EE6yzGR7MVmxDhG0yW2t7DHnGkKOxwjY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)";
    homepage = "https://github.com/davidB/kubectl-view-allocations";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ mrene ];
    platforms = lib.platforms.unix;
  };
})
