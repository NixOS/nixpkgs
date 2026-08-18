{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-public-voting";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-public-voting";
    rev = "v${version}";
    hash = "sha256-nvMDOvxVJ97JBAQFi4BuMkdtWLODnopfFCoPzExbu00=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_public_voting" ];

  meta = {
    description = "Public voting plugin for pretalx";
    homepage = "https://github.com/pretalx/pretalx-public-voting";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
