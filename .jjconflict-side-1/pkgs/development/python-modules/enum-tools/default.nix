{
  lib,
  buildPythonPackage,
  fetchPypi,
  pygments,
  whey,
}:

buildPythonPackage (finalAttrs: {
  pname = "enum-tools";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    pname = "enum_tools";
    inherit (finalAttrs) version;
    hash = "sha256-DRMzXjYdMA3A+P2CyM+ZUUFyRvlnYUT17hdh62kCKOs=";
  };

  build-system = [
    whey
  ];

  dependencies = [
    pygments
  ];

  pythonImportsCheck = [ "enum_tools" ];

  meta = {
    description = "Tools to expand Python's enum module";
    homepage = "https://github.com/domdfcoding/enum_tools";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
  };
})
