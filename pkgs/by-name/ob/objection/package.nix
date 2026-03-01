{
  lib,
  python3Packages,
  fetchFromGitHub,
  frida-tools,
}:

python3Packages.buildPythonApplication rec {
  pname = "objection";
  version = "1.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "objection";
    tag = version;
    hash = "sha256-xOqBYwpq46czRZggTNmNcqGqTA8omTLiOeZaF7zSvxo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  buildInputs = [
    frida-tools
  ];

  dependencies = with python3Packages; [
    frida-python
    prompt-toolkit
    click
    tabulate
    semver
    delegator-py
    requests
    flask
    pygments
    setuptools
    packaging
    litecli
  ];

  pythonImportsCheck = [
    "objection"
  ];

  doCheck = true;

  pythonRuntimeDepsCheck = true;

  meta = {
    description = "Runtime mobile exploration toolkit, powered by Frida";
    longDescription = ''
      objection is a runtime mobile exploration toolkit, powered by Frida,
      built to help you assess the security posture of your mobile applications,
      without needing a jailbreak.
    '';
    homepage = "https://github.com/sensepost/objection";
    changelog = "https://github.com/sensepost/objection/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nullstring1 ];
    mainProgram = "objection";
  };
}
