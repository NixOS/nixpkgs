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
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "hexora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xBg8Rrtwgg8Obi7JOPwdRXwoQKL8skCY72vLJA/VPRk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Xc6CcJ6s8X7T04W2SP7XT2rKGh2TatkaCxP2sSUC+2Y=";
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
