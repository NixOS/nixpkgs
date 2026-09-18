{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "spf-engine";
  version = "3.1.0";
  pyproject = true;

  src = fetchurl {
    url = "https://launchpad.net/spf-engine/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.version}/+download/spf-engine-${finalAttrs.version}.tar.gz";
    hash = "sha256-HUuMxYFCqItLFgMSnrkwfmJWqgFGyI1RWgmljb+jkWk=";
  };

  nativeBuildInputs = [
    python3Packages.flit-core
  ];

  dependencies = with python3Packages; [
    pyspf
    dnspython
    authres
    pymilter
  ];

  pythonImportsCheck = [
    "spf_engine"
    "spf_engine.milter_spf"
    "spf_engine.policyd_spf"
  ];

  meta = {
    homepage = "https://launchpad.net/spf-engine/";
    description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
})
