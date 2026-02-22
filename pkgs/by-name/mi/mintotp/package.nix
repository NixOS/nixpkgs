{
  python3Packages,
  fetchPypi,
  lib,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mintotp";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0PTbXts4p0gRIBdqUm6MKVObnoBYHdLcwYEVV9d8+tU=";
  };

  build-system = [ python3Packages.setuptools ];

  meta = {
    description = "Minimal TOTP generator";
    homepage = "https://github.com/susam/mintotp";
    changelog = "https://github.com/susam/mintotp/raw/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    mainProgram = "mintotp";
    maintainers = with lib.maintainers; [ provokateurin ];
  };
})
