{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.18.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-GiuGPnyYL0HQ/J2OpDTD1/panZCuzKtD3mKW5op5lXA=";
  };

  patches = [ ./dont-fetch-submodule.patch ];

  nativeBuildInputs = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # import from $out
    rm ua_parser/__init__.py
  '';

  pythonImportsCheck = [ "ua_parser" ];

  meta = with lib; {
    description = "Python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
