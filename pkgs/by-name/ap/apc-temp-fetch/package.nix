{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apc-temp-fetch";
  version = "0.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "APC-Temp-fetch";
    inherit (finalAttrs) version;
    hash = "sha256-lXGj/xrOkdMMYvuyVVSCojjQlzISFUT14VTn//iOARo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
  ];

  pythonImportsCheck = [
    "APC_Temp_fetch"
  ];

  meta = {
    description = "Unified temperature fetcher interface to several UPS network adapters";
    homepage = "https://github.com/YZITE/APC_Temp_fetch";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
