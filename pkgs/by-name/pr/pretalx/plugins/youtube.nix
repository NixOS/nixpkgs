{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-youtube";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-youtube";
    rev = "v${version}";
    hash = "sha256-5vQPFW0qABKQjFUvjMrtmIGEpMzLLbAOBA4GFqqBNw0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_youtube" ];

  meta = {
    description = "Static youtube for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-youtube";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
