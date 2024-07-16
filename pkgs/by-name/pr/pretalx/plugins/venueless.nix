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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-venueless";
    rev = "v${version}";
    hash = "sha256-h8o5q1roFm8Bct/Qf8obIJYkkGPcz3WJ15quxZH48H8=";
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
