{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "subcat";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duty1g";
    repo = "subcat";
    # https://github.com/duty1g/subcat/issues/10
    rev = "19535a896f60573a234d5b266d08cc6e78d8a525";
    hash = "sha256-E6gK5CHuFyu3GPyofHErlu92RAgl6jBPfWbTTX3aNtA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiohttp
    dnspython
    playwright
    pyyaml
    requests
    rich
    urllib3
  ];

  pythonImportsCheck = [ "subcat" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Subdomain discovery tool";
    homepage = "https://github.com/duty1g/subcat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "subcat";
  };
}
