{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "scdl";
  version = "2.12.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5+3ok7UcJEdUW45bdPGkkvk+k/NYIpEi0URNuQ6e0vk=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    docopt-ng
    mutagen
    termcolor
    requests
    tqdm
    pathvalidate
    soundcloud-v2
    filelock
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "scdl" ];

  meta = with lib; {
    description = "Download Music from Soundcloud";
    homepage = "https://github.com/flyingrub/scdl";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "scdl";
  };
}
