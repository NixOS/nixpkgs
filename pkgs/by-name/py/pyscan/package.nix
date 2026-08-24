{
  lib,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  python3Packages,
  rustc,
  rustPlatform,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyscan";
  version = "0.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ohaswin";
    repo = "pyscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n1mwOYntWyW7lPKPLgG7PteTRh3mly5vqbKy2R/9xnw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QzFUoHfvjd6ZMkKIsGXIVyks2LxdJblIiQccsOoYcJs=";
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Project has no test
  doCheck = false;

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python dependency vulnerability scanner";
    homepage = "https://github.com/ohaswin/pyscan";
    changelog = "https://github.com/ohaswin/pyscan/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pyscan";
  };
})
