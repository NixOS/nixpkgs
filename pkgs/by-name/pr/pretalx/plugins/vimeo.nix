{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-vimeo";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-vimeo";
    rev = "v${version}";
    hash = "sha256-ZlF/wWD5FaC4CfYIYvcbykPajoCOotmmaY+rQ0sGAo8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_vimeo" ];

  meta = {
    description = "Static vimeo for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-vimeo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
