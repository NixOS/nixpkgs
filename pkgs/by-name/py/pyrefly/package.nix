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
  version = "0.24.2";
  pyproject = true;

  # fetch from PyPI instead of GitHub, since source repo does not have Cargo.lock
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZxuZM8Kj9kaYPeaLwEInNvfONkxPZF90JVlCOwubUVA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-/CClXkZU1YOQ1W5j8BuelZmL6ug+ipq7IYYqd4p0iQg=";
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
