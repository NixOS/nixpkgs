{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-pages";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-pages";
    rev = "v${version}";
    hash = "sha256-Wzd3uf+mdoyeMCZ4ZYcPLGqlUWCqSL02eeKRubTiH00=";
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
