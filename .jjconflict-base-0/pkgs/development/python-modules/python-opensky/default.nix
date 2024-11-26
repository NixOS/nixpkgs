{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-opensky";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-opensky";
    rev = "refs/tags/v${version}";
    hash = "sha256-V6iRwWzCnPCvu8eks2sHPYrX3OmaFnNj+i57kQJKYm0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
    substituteInPlace src/python_opensky/opensky.py \
      --replace ".joinpath(uri)" "/ uri"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "python_opensky" ];

  meta = with lib; {
    description = "Asynchronous Python client for the OpenSky API";
    homepage = "https://github.com/joostlek/python-opensky";
    changelog = "https://github.com/joostlek/python-opensky/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
