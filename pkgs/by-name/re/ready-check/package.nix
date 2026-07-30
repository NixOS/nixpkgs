{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ready-check";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sesh";
    repo = "ready";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QdYg2kemfZCY5RkEiry1U5eLStd10HdRpQHn7+hOL/g=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    cryptography
    thttp
    tld
  ];

  pythonImportsCheck = [
    "ready"
  ];

  meta = {
    description = "Tool to check readiness of websites";
    homepage = "https://github.com/sesh/ready";
    changelog = "https://github.com/sesh/ready/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ready";
  };
})
