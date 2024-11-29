{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "4.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mrRg61fwBrcfl3ppPRVyFaq9a7y8bNZCi2lR6q4MKHU=";
  };

  build-system = [ setuptools ];

  # Tests require additional permissions
  doCheck = false;

  pythonImportsCheck = [ "ping3" ];

  meta = with lib; {
    description = "ICMP ping implementation using raw socket";
    homepage = "https://github.com/kyan001/ping3";
    changelog = "https://github.com/kyan001/ping3/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "ping3";
  };
}
