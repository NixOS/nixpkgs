{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication {
  pname = "plecost";
  version = "0-unstable-2022-08-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iniqua";
    repo = "plecost";
    # Release is untagged
    rev = "4895e345d71bffe956be43530632e303dd379a5f";
    hash = "sha256-cXXFLoiLZpo3qiAPztavns4EkOG2aC6UKMf0N4Eun/w=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    async-timeout
    termcolor
    lxml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "plecost_lib" ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = with lib; {
    description = "Vulnerability fingerprinting and vulnerability finder for Wordpress blog engine";
    mainProgram = "plecost";
    homepage = "https://github.com/iniqua/plecost";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
  };
}
