{
  python3,
  buildPythonPackage,
  rustPlatform,
  pkg-config,
  bzip2,
  zstd,
  pytestCheckHook,

  ironcalc,
}:

buildPythonPackage {
  pname = "ironcalc";
  inherit (ironcalc) src version;
  pyproject = true;

  postPatch = ''
    cd bindings/python
  '';

  strictDeps = true;
  __structuredAttrs = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (ironcalc) src;
    hash = ironcalc.cargoHash;
  };

  cargoRoot = "../..";

  env.PYO3_PYTHON = "${python3}/bin/python3";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ironcalc" ];

  meta = ironcalc.meta // {
    description = "Python bindings for IronCalc";
  };
}
