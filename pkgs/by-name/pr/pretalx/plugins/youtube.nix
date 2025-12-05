{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-youtube";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-youtube";
    rev = "v${version}";
    hash = "sha256-vOgzYxF3MHzzcUb8TMLRSyuRc6RHcxvCWxAFRFAf1Cs=";
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
