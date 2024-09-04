{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-pages";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-pages";
    rev = "v${version}";
    hash = "sha256-wLMl+2hAJQksCyeBnXxMIFh1/Qkosm7PqByW6QxMsyg=";
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
