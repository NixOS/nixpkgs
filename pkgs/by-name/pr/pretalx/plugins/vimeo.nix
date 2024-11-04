{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-vimeo";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-vimeo";
    rev = "v${version}";
    hash = "sha256-MwAKmPQif2wLy03II1t87lIdIf2th4BteaAo5pACjLE=";
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
