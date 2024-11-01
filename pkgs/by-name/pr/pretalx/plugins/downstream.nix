{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretalx-downstream";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretalx";
    repo = "pretalx-downstream";
    rev = "v${version}";
    hash = "sha256-Q9519jNKQUeNCHg3ivjYyQm1ePMxp/bhtcJAselQiiM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pretalx_downstream" ];

  meta = {
    description = "Use pretalx passively by importing another event's schedule";
    homepage = "https://github.com/pretalx/pretalx-downstream";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
