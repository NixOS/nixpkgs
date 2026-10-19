{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sapcli";
  version = "1.0.0-unstable-2026-10-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jfilak";
    repo = "sapcli";
    rev = "767e665d3ce9c51b2da66672dd40f2424c316eeb";
    hash = "sha256-5g00aw9MqSirbp645tFCcX/eLeMc+b58OoYCLI4K5kA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.0.0" setuptools
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    platformdirs
    pyodata
    pyyaml
    requests
    truststore
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)
    python -m unittest discover -b -v -s test/unit
    runHook postCheck
  '';

  pythonImportsCheck = [ "sap" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Command line interface to SAP products";
    homepage = "https://github.com/jfilak/sapcli";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "sapcli";
  };
})
