{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;

  pname = "hermeneutic";
  version = "0.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ruRH/rGP6tptvOx1ECgXDM49WhdMAvwR4JIcBiCGZq4=";
  };

  build-system = [ python3Packages.hatchling ];

  pythonImportsCheck = [ "hermeneutic" ];

  meta = {
    description = "Mine correction evidence and run a deterministic English drift check";
    homepage = "https://github.com/hermes-labs-ai/hermeneutic";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "hermeneutic";
  };
})
