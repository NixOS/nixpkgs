{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  jinja2,
  markupsafe,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "aiohttp-swagger";
  version = "1.0.15";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cr0hn";
    repo = pname;
    rev = version;
    hash = "sha256-M43sNpbXWXFRTd549cZhvhO35nBB6OH+ki36BzSk87Q=";
  };

  propagatedBuildInputs = [
    aiohttp
    jinja2
    markupsafe
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "markupsafe~=1.1.1" "markupsafe>=1.1.1" \
      --replace "jinja2~=2.11.2" "jinja2>=2.11.2"
  '';

  preCheck = ''
    # The custom client is obsolete
    rm tests/conftest.py
  '';

  pythonImportsCheck = [ "aiohttp_swagger" ];

  meta = with lib; {
    description = "Swagger API Documentation builder for aiohttp";
    homepage = "https://github.com/cr0hn/aiohttp-swagger";
    license = licenses.mit;
  };
}
