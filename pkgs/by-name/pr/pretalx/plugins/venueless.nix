{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  setuptools,
  django,
  pyjwt,
}:

buildPythonPackage rec {
  pname = "pretalx-venueless";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-venueless";
    rev = "v${version}";
    hash = "sha256-1YWkyTaImnlGXZWrborvJrx8zc1FOZD/ugOik7S+fC8=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = [ setuptools ];

  dependencies = [
    django
    pyjwt
  ];

  pythonImportsCheck = [ "pretalx_venueless" ];

  meta = {
    description = "Static venueless for pretalx, e.g. information, venue listings, a Code of Conduct, etc";
    homepage = "https://github.com/pretalx/pretalx-venueless";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
