{
  lib,
  python3Packages,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gersemi";
  version = "0.28.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    tag = finalAttrs.version;
    hash = "sha256-eKaloLttIzBsLSNroTQLAN5WKvL5M/u0d6eSlw58oro=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    sourceRoot = "${finalAttrs.src.name}/gersemi/rust-backend";
    hash = "sha256-2ukdpS5oNDE9kf0zFrPXyh+6zA/l0ByUhb71xhJJ8nA=";
  };

  cargoRoot = "gersemi/rust-backend";

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  build-system = with python3Packages; [
    setuptools-rust
  ];

  dependencies = with python3Packages; [
    appdirs
    colorama
    lark
    pyyaml
  ];

  meta = {
    description = "Formatter to make your CMake code the real treasure";
    homepage = "https://github.com/BlankSpruce/gersemi";
    changelog = "https://github.com/BlankSpruce/gersemi/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ xeals ];
    mainProgram = "gersemi";
  };
})
