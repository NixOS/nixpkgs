{ lib
, python3
, fetchPypi
, frida-tools
}:

python3.pkgs.buildPythonApplication rec {
  pname = "objection";
  version = "1.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HhZ+FXlyC2ijvMMM9F5iv5i6OUIwfMTN9OQgHzkguHo==";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  buildInputs = [
    frida-tools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    frida-python
    prompt-toolkit
    click
    tabulate
    (semver.overridePythonAttrs (oldAttrs: rec {
      version = "2.13.0";
      src = fetchPypi {
        pname = "semver";
        inherit version;
        hash = "sha256-+g/ici7hw/V+rEeIIMOlri9iSvgmTL35AAyYD/f3Xj8=";
      };
      doCheck = false;
      nativeCheckInputs = [];
    }))
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

  doCheck = false;

  pythonRuntimeDepsCheck = false;

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
