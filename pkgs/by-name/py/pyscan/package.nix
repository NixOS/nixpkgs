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
  version = "2.1.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ohaswin";
    repo = "pyscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I5Chs9N/ZH7NM1CsaIKjO0eS68/t+wZaHGEO59Ur/+8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Y3fxKYpGJCX4VECe0mmP2lDZc4efd9tNXY8YLeQXXRk=";
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
