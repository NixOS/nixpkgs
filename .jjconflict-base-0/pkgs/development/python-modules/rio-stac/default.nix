{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  flit,

  # dependencies
  pystac,
  rasterio,

  # test
  jsonschema,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "rio-stac";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "rio-stac";
    tag = version;
    hash = "sha256-sK03AWDwsUanxl756z/MrroF3cm7hV3dpPhVQ/1cs3E=";
  };

  build-system = [ flit ];

  dependencies = [
    pystac
    rasterio
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rio_stac" ];

  disabledTests = [
    # urllib url open error
    "test_create_item"
  ];

  # the build should should also generate a program for cli, but nothing is installed in $out/bin
  # related comment: https://github.com/NixOS/nixpkgs/pull/392056#issuecomment-2751934248
  meta = {
    description = "Create STAC Items from raster datasets";
    homepage = "https://github.com/developmentseed/rio-stac";
    changelog = "https://github.com/developmentseed/rio-stac/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
