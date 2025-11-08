{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-pages";
  version = "1.7.0";
  pyproject = true;

  # TODO: https://github.com/pretalx/pretalx-pages/issues/6
  src = fetchPypi {
    pname = "pretalx_pages";
    inherit version;
    hash = "sha256-XFZS0FUzouZzVh9AADK5dnezFZiAWoBihD4C184+690=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_pages" ];

  meta = {
    description = "Static pages for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-pages";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
