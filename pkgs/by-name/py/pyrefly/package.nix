{
  lib,
  python3,
  fetchPypi,
  versionCheckHook,
  nix-update-script,
  rustPlatform,
  maturin,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pyrefly";
  version = "0.25.1";
  pyproject = true;

  # fetch from PyPI instead of GitHub, since source repo does not have Cargo.lock
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lSX/+ygP9//dP7XSZYqhOFuz7zaH49Crvi5IuqLXL6E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-YFFDh563o25vi/T95uKeT1UHfOljFKJRexidBgl02pE=";
  };

  build-system = [ maturin ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ versionCheckHook ];

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
}
