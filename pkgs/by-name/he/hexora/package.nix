{
  lib,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  python3Packages,
  rustc,
  rustPlatform,
  zstd,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hexora";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "hexora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c0+E9Lc9EY14O423Vp5GGmCHzHXkbAhFztyxF4695x8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QIFgq1e4qRJillhln6jyJfRZS6oMwlUlaDADWnhr2qE=";
  };

  build-system = [
    cargo
    pkg-config
    python3Packages.setuptools
    python3Packages.setuptools-rust
    python3Packages.wheel
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [ zstd ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "hexora" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static analysis of malicious Python code";
    homepage = "https://github.com/rushter/hexora";
    changelog = "https://github.com/rushter/hexora/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hexora";
  };
})
