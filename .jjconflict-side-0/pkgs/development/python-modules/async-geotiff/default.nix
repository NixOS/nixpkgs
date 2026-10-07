{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,

  affine,
  async-tiff,
  defusedxml,
  numpy,
  pyproj,

  # tests
  pydantic,
  rasterio,
  morecantile,
  jsonschema,
  pytest-asyncio,
}:
buildPythonPackage (finalAttrs: {
  pname = "async-geotiff";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "async-geotiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VC4I1ZDKC2Joh2lxscZ1UWp5p5wOEPKjTq+Ty2Z0PJc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "uv_build>=0.8.8,<0.12.0" "uv_build>=0.8.8,<0.13.0"
  '';

  build-system = [ uv-build ];

  dependencies = [
    affine
    async-tiff
    defusedxml
    numpy
    pyproj
  ];

  pythonImportsCheck = [ "async_geotiff" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    jsonschema
    morecantile
    rasterio
    pydantic
    pytest-asyncio
  ];

  meta = {
    description = "Fast, async GeoTIFF and COG reader for Python";
    homepage = "https://developmentseed.org/async-geotiff/latest/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
})
